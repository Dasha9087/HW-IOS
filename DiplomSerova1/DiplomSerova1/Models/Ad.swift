//
//  Ad.swift
//  DiplomSerova1
//
//  Created by Дарья on 08.11.2026.
//

import Foundation

struct Ad: Codable, Identifiable {
    let id: String
    let title: String
    let description: String
    let price: Int
    let category: String
    let city: String
    let userId: String
    let createdAt: TimeInterval
}

enum AdFormatter {
    static func price(_ value: Int) -> String {
        "\(value) р."
    }

    static func date(_ timestamp: TimeInterval) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "d MMM yyyy"

        return formatter.string(
            from: Date(timeIntervalSince1970: timestamp)
        )
    }
}
