//
//  AdCategory.swift
//  DiplomSerova1
//
//  Created by Дарья on 08.11.2026.
//

import Foundation

enum AdCategory: String, CaseIterable, Codable, Identifiable {
    case cars = "Легковые"
    case moto = "Мото"
    case parts = "Запчасти"
    case tires = "Шины и диски"
    case commercial = "Коммерческие"

    var id: String {
        rawValue
    }

    var iconName: String {
        switch self {
        case .cars:
            return "car.fill"
        case .moto:
            return "bicycle"
        case .parts:
            return "wrench.fill"
        case .tires:
            return "circle.fill"
        case .commercial:
            return "bus.fill"
        }
    }
}
