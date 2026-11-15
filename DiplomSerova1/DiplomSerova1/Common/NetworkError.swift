//
//  NetworkError.swift
//  DiplomSerova1
//
//  Created by Дарья on 08.11.2026.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidUrl
    case invalidResponse(Error)
    case invalidStatusCode
    case parsingError
    case notAuthorized

    var errorDescription: String? {
        switch self {
        case .invalidUrl:
            return "Некорректный запрос"
        case .invalidResponse:
            return "Нет соединения"
        case .invalidStatusCode:
            return "Сервер ответил ошибкой"
        case .parsingError:
            return "Не удалось прочитать данные"
        case .notAuthorized:
            return "Нужно войти в аккаунт"
        }
    }
}

