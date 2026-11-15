//
//  AdsService.swift
//  DiplomSerova1
//
//  Created by Дарья on 08.11.2026.
//

import Foundation
import FirebaseFirestore

final class AdsService: AdsServiceable {
    private let db = Firestore.firestore()
    private var lastDocument: DocumentSnapshot?
    private var isFetching = false

    private var cachedCatalogAds: [Ad] = []
    private var hasReturnedCatalogCache = false

    func resetPagination() {
        lastDocument = nil
        isFetching = false
        cachedCatalogAds = AdsCacheService.shared.loadAds(
            forKey: AdsCacheKey.catalog
        ) ?? []
        hasReturnedCatalogCache = false
    }

    func fetchNextAds(
        limit: Int,
        completion: @escaping (Result<[Ad], NetworkError>) -> Void
    ) {
        guard !isFetching else { return }

        if hasReturnedCatalogCache {
            completion(.success([]))
            return
        }

        if lastDocument == nil && cachedCatalogAds.isEmpty {
            cachedCatalogAds = AdsCacheService.shared.loadAds(
                forKey: AdsCacheKey.catalog
            ) ?? []
        }

        let isFirstPage = lastDocument == nil
        isFetching = true

        var query: Query = db.collection("ads")
            .order(by: "createdAt", descending: true)
            .limit(to: limit)

        if let lastDocument {
            query = query.start(afterDocument: lastDocument)
        }

        query.getDocuments { [weak self] snapshot, error in
            guard let self = self else { return }
            self.isFetching = false

            if let error = error {
                self.completeCatalogRequest(
                    with: .invalidResponse(error),
                    isFirstPage: isFirstPage,
                    completion: completion
                )
                return
            }

            guard let snapshot = snapshot else {
                self.completeCatalogRequest(
                    with: .parsingError,
                    isFirstPage: isFirstPage,
                    completion: completion
                )
                return
            }

            if let lastDocument = snapshot.documents.last {
                self.lastDocument = lastDocument
            }

            let ads = snapshot.documents.compactMap {
                Self.makeAd(id: $0.documentID, data: $0.data())
            }

            if isFirstPage {
                self.cachedCatalogAds = self.mergeAds([], with: ads)
            } else {
                self.cachedCatalogAds = self.mergeAds(
                    self.cachedCatalogAds,
                    with: ads
                )
            }

            AdsCacheService.shared.saveAds(
                self.cachedCatalogAds,
                forKey: AdsCacheKey.catalog
            )

            completion(.success(ads))
        }
    }

    func createAd(
        title: String,
        description: String,
        price: Int,
        category: String,
        city: String,
        userId: String,
        completion: @escaping (Result<Void, NetworkError>) -> Void
    ) {
        let reference = db.collection("ads").document()
        let createdAt = Date().timeIntervalSince1970

        reference.setData([
            "title": title,
            "description": description,
            "price": price,
            "category": category,
            "city": city,
            "userId": userId,
            "createdAt": FieldValue.serverTimestamp()
        ]) { [weak self] error in
            if let error = error {
                completion(.failure(.invalidResponse(error)))
                return
            }

            let ad = Ad(
                id: reference.documentID,
                title: title,
                description: description,
                price: price,
                category: category,
                city: city,
                userId: userId,
                createdAt: createdAt
            )

            self?.saveMyAdToCache(ad, userId: userId)
            completion(.success(()))
        }
    }

    func deleteAd(
        adId: String,
        userId: String,
        completion: @escaping (Result<Void, NetworkError>) -> Void
    ) {
        let adReference = db.collection("ads").document(adId)

        adReference.getDocument { [weak self] snapshot, error in
            guard let self = self else { return }

            if let error = error {
                completion(.failure(.invalidResponse(error)))
                return
            }

            guard
                let snapshot = snapshot,
                snapshot.exists,
                let ownerId = snapshot.data()?["userId"] as? String,
                ownerId == userId
            else {
                completion(.failure(.parsingError))
                return
            }

            let favoriteReference = self.db.collection("users")
                .document(userId)
                .collection("favorites")
                .document(adId)

            let batch = self.db.batch()
            batch.deleteDocument(adReference)
            batch.deleteDocument(favoriteReference)

            batch.commit { [weak self] error in
                guard let self = self else { return }

                if let error = error {
                    completion(.failure(.invalidResponse(error)))
                    return
                }

                self.removeAdFromCaches(adId: adId, userId: userId)
                completion(.success(()))
            }
        }
    }

    func fetchMyAds(
        userId: String,
        completion: @escaping (Result<[Ad], NetworkError>) -> Void
    ) {
        let cacheKey = AdsCacheKey.myAds(userId: userId)

        db.collection("ads")
            .whereField("userId", isEqualTo: userId)
            .getDocuments { snapshot, error in
                if let error = error {
                    if let cachedAds = AdsCacheService.shared.loadAds(
                        forKey: cacheKey
                    ) {
                        completion(.success(cachedAds))
                    } else {
                        completion(.failure(.invalidResponse(error)))
                    }
                    return
                }

                guard let snapshot = snapshot else {
                    if let cachedAds = AdsCacheService.shared.loadAds(
                        forKey: cacheKey
                    ) {
                        completion(.success(cachedAds))
                    } else {
                        completion(.failure(.parsingError))
                    }
                    return
                }

                let ads = snapshot.documents.compactMap {
                    Self.makeAd(id: $0.documentID, data: $0.data())
                }

                let sortedAds = ads.sorted {
                    $0.createdAt > $1.createdAt
                }

                AdsCacheService.shared.saveAds(
                    sortedAds,
                    forKey: cacheKey
                )
                completion(.success(sortedAds))
            }
    }

    func fetchFavorites(
        userId: String,
        completion: @escaping (Result<[Ad], NetworkError>) -> Void
    ) {
        let cacheKey = AdsCacheKey.favorites(userId: userId)

        db.collection("users")
            .document(userId)
            .collection("favorites")
            .getDocuments { snapshot, error in
                if let error = error {
                    if let cachedAds = AdsCacheService.shared.loadAds(
                        forKey: cacheKey
                    ) {
                        completion(.success(cachedAds))
                    } else {
                        completion(.failure(.invalidResponse(error)))
                    }
                    return
                }

                guard let snapshot = snapshot else {
                    if let cachedAds = AdsCacheService.shared.loadAds(
                        forKey: cacheKey
                    ) {
                        completion(.success(cachedAds))
                    } else {
                        completion(.failure(.parsingError))
                    }
                    return
                }

                let ads = snapshot.documents.compactMap {
                    Self.makeAd(id: $0.documentID, data: $0.data())
                }

                let sortedAds = ads.sorted {
                    $0.createdAt > $1.createdAt
                }

                AdsCacheService.shared.saveAds(
                    sortedAds,
                    forKey: cacheKey
                )
                completion(.success(sortedAds))
            }
    }

    func addFavorite(
        _ ad: Ad,
        userId: String,
        completion: @escaping (Result<Void, NetworkError>) -> Void
    ) {
        db.collection("users")
            .document(userId)
            .collection("favorites")
            .document(ad.id)
            .setData([
                "title": ad.title,
                "description": ad.description,
                "price": ad.price,
                "category": ad.category,
                "city": ad.city,
                "userId": ad.userId,
                "createdAt": Timestamp(
                    date: Date(timeIntervalSince1970: ad.createdAt)
                )
            ]) { [weak self] error in
                if let error = error {
                    completion(.failure(.invalidResponse(error)))
                    return
                }

                self?.updateFavoritesCache(
                    ad: ad,
                    adId: ad.id,
                    userId: userId
                )
                completion(.success(()))
            }
    }

    func removeFavorite(
        adId: String,
        userId: String,
        completion: @escaping (Result<Void, NetworkError>) -> Void
    ) {
        db.collection("users")
            .document(userId)
            .collection("favorites")
            .document(adId)
            .delete { [weak self] error in
                if let error = error {
                    completion(.failure(.invalidResponse(error)))
                    return
                }

                self?.updateFavoritesCache(
                    ad: nil,
                    adId: adId,
                    userId: userId
                )
                completion(.success(()))
            }
    }

    private func completeCatalogRequest(
        with error: NetworkError,
        isFirstPage: Bool,
        completion: @escaping (Result<[Ad], NetworkError>) -> Void
    ) {
        if isFirstPage && cachedCatalogAds.isEmpty {
            cachedCatalogAds = AdsCacheService.shared.loadAds(
                forKey: AdsCacheKey.catalog
            ) ?? []
        }

        if isFirstPage && !cachedCatalogAds.isEmpty {
            hasReturnedCatalogCache = true
            completion(.success(cachedCatalogAds))
        } else {
            completion(.failure(error))
        }
    }

    private func mergeAds(_ existingAds: [Ad], with newAds: [Ad]) -> [Ad] {
        var result = existingAds

        for ad in newAds {
            if let index = result.firstIndex(where: { $0.id == ad.id }) {
                result[index] = ad
            } else {
                result.append(ad)
            }
        }

        return result.sorted {
            $0.createdAt > $1.createdAt
        }
    }

    private func saveMyAdToCache(_ ad: Ad, userId: String) {
        let cacheKey = AdsCacheKey.myAds(userId: userId)
        var ads = AdsCacheService.shared.loadAds(forKey: cacheKey) ?? []

        ads.removeAll { $0.id == ad.id }
        ads.insert(ad, at: 0)

        AdsCacheService.shared.saveAds(ads, forKey: cacheKey)
    }

    private func removeAdFromCaches(adId: String, userId: String) {
        cachedCatalogAds.removeAll { $0.id == adId }

        let catalogAds = AdsCacheService.shared.loadAds(
            forKey: AdsCacheKey.catalog
        ) ?? []

        AdsCacheService.shared.saveAds(
            catalogAds.filter { $0.id != adId },
            forKey: AdsCacheKey.catalog
        )

        let myAdsKey = AdsCacheKey.myAds(userId: userId)
        let myAds = AdsCacheService.shared.loadAds(forKey: myAdsKey) ?? []

        AdsCacheService.shared.saveAds(
            myAds.filter { $0.id != adId },
            forKey: myAdsKey
        )

        let favoritesKey = AdsCacheKey.favorites(userId: userId)
        let favorites = AdsCacheService.shared.loadAds(forKey: favoritesKey) ?? []

        AdsCacheService.shared.saveAds(
            favorites.filter { $0.id != adId },
            forKey: favoritesKey
        )
    }

    private func updateFavoritesCache(
        ad: Ad?,
        adId: String,
        userId: String
    ) {
        let cacheKey = AdsCacheKey.favorites(userId: userId)
        var ads = AdsCacheService.shared.loadAds(forKey: cacheKey) ?? []

        ads.removeAll { $0.id == adId }

        if let ad = ad {
            ads.insert(ad, at: 0)
        }

        AdsCacheService.shared.saveAds(ads, forKey: cacheKey)
    }

    private static func makeAd(id: String, data: [String: Any]) -> Ad? {
        guard
            let title = data["title"] as? String,
            let description = data["description"] as? String,
            let category = data["category"] as? String,
            let city = data["city"] as? String,
            let userId = data["userId"] as? String
        else {
            return nil
        }

        let price: Int

        if let value = data["price"] as? Int {
            price = value
        } else if let value = data["price"] as? Double {
            price = Int(value)
        } else {
            return nil
        }

        let createdAt: TimeInterval

        if let timestamp = data["createdAt"] as? Timestamp {
            createdAt = timestamp.dateValue().timeIntervalSince1970
        } else {
            createdAt = Date().timeIntervalSince1970
        }

        return Ad(
            id: id,
            title: title,
            description: description,
            price: price,
            category: category,
            city: city,
            userId: userId,
            createdAt: createdAt
        )
    }
}
