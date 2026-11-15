//
//  AppUser.swift
//  DiplomSerova1
//
//  Created by Дарья on 08.11.2026.
//

import Foundation

struct AppUser: Codable, Identifiable {
    let id: String
    let name: String
    let email: String
}

