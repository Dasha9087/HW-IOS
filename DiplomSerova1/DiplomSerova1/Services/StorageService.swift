//
//  StorageService.swift
//  DiplomSerova1
//
//  Created by Дарья on 08.11.2026.
//

import Foundation

final class StorageService: StorageServiceable {

    static let shared = StorageService()

    private enum UserDefaultsKey {
        static let currentUser = "currentUser"
        static let searchHistory = "searchHistory"
    }

    private init() {}

    @UserDefault(key: UserDefaultsKey.currentUser, defaultValue: nil)
    private var currentUser: AppUser?

    @UserDefault(key: UserDefaultsKey.searchHistory, defaultValue: [String]())
    private var history: [String]

    func saveUser(_ user: AppUser) {
        currentUser = user
    }

    func getUser() -> AppUser? {
        currentUser
    }

    func clearSession() {
        currentUser = nil
        history = []
    }

    func getSearchHistory() -> [String] {
        history
    }

    func addSearch(_ text: String) {
        var items = history
        items.removeAll {
            $0.caseInsensitiveCompare(text) == .orderedSame
        }
        items.insert(text, at: 0)

        if items.count > 10 {
            items = Array(items.prefix(10))
        }

        history = items
    }

    func clearHistory() {
        history = []
    }
}
