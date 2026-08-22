import Foundation

enum NetworkError: Error {

    case invalidURL
    case requestFailed(Error)
    case invalidStatusCode
    case decodingError

}

