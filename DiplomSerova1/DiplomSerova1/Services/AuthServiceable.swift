//
//  AuthServiceable.swift
//  DiplomSerova1
//
//  Created by Дарья on 08.11.2026.
//

import Foundation

protocol AuthServiceable {
    var currentUserId: String? { get }

    func login(
        with email: String,
        password: String,
        completion: @escaping (Result<AppUser, NetworkError>) -> Void
    )

    func register(
        with email: String,
        password: String,
        name: String,
        completion: @escaping (Result<AppUser, NetworkError>) -> Void
    )

    func fetchUser(
        completion: @escaping (Result<AppUser, NetworkError>) -> Void
    )

    func signOut() throws
}
