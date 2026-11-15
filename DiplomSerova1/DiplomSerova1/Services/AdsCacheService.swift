//
//  AdsCacheService.swift
//  DiplomSerova1
//
//  Created by Дарья on 08.11.2026.
//

import CoreData
import Foundation

@objc(AdsCacheEntry)
class AdsCacheEntry: NSManagedObject {
    @NSManaged var key: String
    @NSManaged var data: Data
    @NSManaged var updatedAt: Date
}

enum AdsCacheKey {
    static let catalog = "catalog"

    static func favorites(userId: String) -> String {
        "favorites_\(userId)"
    }

    static func myAds(userId: String) -> String {
        "myAds_\(userId)"
    }
}

final class AdsCacheService {
    static let shared = AdsCacheService()

    private let container: NSPersistentContainer

    private init() {
        let model = NSManagedObjectModel()
        let entity = NSEntityDescription()

        entity.name = "AdsCacheEntry"
        entity.managedObjectClassName = NSStringFromClass(AdsCacheEntry.self)
        entity.properties = [
            Self.makeAttribute(name: "key", type: .stringAttributeType),
            Self.makeAttribute(name: "data", type: .binaryDataAttributeType),
            Self.makeAttribute(name: "updatedAt", type: .dateAttributeType)
        ]

        model.entities = [entity]

        container = NSPersistentContainer(
            name: "AdsCache",
            managedObjectModel: model
        )
        container.viewContext.automaticallyMergesChangesFromParent = true

        container.loadPersistentStores { _, error in
            if let error = error {
                print("Не удалось открыть кэш объявлений: \(error.localizedDescription)")
            }
        }
    }

    func loadAds(forKey key: String) -> [Ad]? {
        let context = container.viewContext
        var cachedAds: [Ad]?

        context.performAndWait {
            let request = NSFetchRequest<AdsCacheEntry>(
                entityName: "AdsCacheEntry"
            )
            request.fetchLimit = 1
            request.predicate = NSPredicate(format: "key == %@", key)

            do {
                guard let entry = try context.fetch(request).first else {
                    return
                }

                cachedAds = try JSONDecoder().decode(
                    [Ad].self,
                    from: entry.data
                )
            } catch {
                print("Не удалось прочитать кэш объявлений: \(error.localizedDescription)")
            }
        }

        return cachedAds
    }

    func saveAds(_ ads: [Ad], forKey key: String) {
        guard let data = try? JSONEncoder().encode(ads) else { return }

        container.performBackgroundTask { context in
            context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

            let request = NSFetchRequest<AdsCacheEntry>(
                entityName: "AdsCacheEntry"
            )
            request.fetchLimit = 1
            request.predicate = NSPredicate(format: "key == %@", key)

            do {
                let entry = try context.fetch(request).first
                    ?? AdsCacheEntry(context: context)

                entry.key = key
                entry.data = data
                entry.updatedAt = Date()

                try context.save()
            } catch {
                print("Не удалось сохранить кэш объявлений: \(error.localizedDescription)")
            }
        }
    }

    private static func makeAttribute(
        name: String,
        type: NSAttributeType
    ) -> NSAttributeDescription {
        let attribute = NSAttributeDescription()
        attribute.name = name
        attribute.attributeType = type
        attribute.isOptional = false
        return attribute
    }
}
