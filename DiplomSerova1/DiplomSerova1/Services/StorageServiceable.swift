//
//  StorageServiceable.swift
//  DiplomSerova1
//
//  Created by Дарья on 08.11.2026.
//

import Foundation

protocol StorageServiceable {
    func saveUser(_ user: AppUser)
    func getUser() -> AppUser?
    func clearSession()

    func getSearchHistory() -> [String]
    func addSearch(_ text: String)
    func clearHistory()
}
