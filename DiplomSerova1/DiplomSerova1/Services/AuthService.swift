//
//  AuthService.swift
//  DiplomSerova1
//
//  Created by Дарья on 08.11.2026.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

final class AuthService: AuthServiceable {

    private let db = Firestore.firestore()

    var currentUserId: String? {
        Auth.auth().currentUser?.uid
    }

    func login(
        with email: String,
        password: String,
        completion: @escaping (Result<AppUser, NetworkError>) -> Void
    ) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                completion(.failure(.invalidResponse(error)))
                return
            }

            guard let uid = result?.user.uid else {
                completion(.failure(.notAuthorized))
                return
            }

            self?.loadProfile(uid: uid, email: email, completion: completion)
        }
    }

    func register(
        with email: String,
        password: String,
        name: String,
        completion: @escaping (Result<AppUser, NetworkError>) -> Void
    ) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                completion(.failure(.invalidResponse(error)))
                return
            }

            guard let uid = result?.user.uid else {
                completion(.failure(.notAuthorized))
                return
            }

            self?.db.collection("users").document(uid).setData([
                "name": name,
                "email": email
            ]) { error in
                if let error = error {
                    completion(.failure(.invalidResponse(error)))
                    return
                }

                let user = AppUser(id: uid, name: name, email: email)
                completion(.success(user))
            }
        }
    }

    func fetchUser(
        completion: @escaping (Result<AppUser, NetworkError>) -> Void
    ) {
        guard let user = Auth.auth().currentUser else {
            completion(.failure(.notAuthorized))
            return
        }

        loadProfile(
            uid: user.uid,
            email: user.email ?? "",
            completion: completion
        )
    }

    func signOut() throws {
        try Auth.auth().signOut()
    }

    private func loadProfile(
        uid: String,
        email: String,
        completion: @escaping (Result<AppUser, NetworkError>) -> Void
    ) {
        db.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                completion(.failure(.invalidResponse(error)))
                return
            }

            let name = snapshot?.data()?["name"] as? String ?? email
            let savedEmail = snapshot?.data()?["email"] as? String ?? email

            let user = AppUser(id: uid, name: name, email: savedEmail)
            completion(.success(user))
        }
    }
}
