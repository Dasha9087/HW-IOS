//
//  AuthPresenter.swift
//  DiplomSerova1
//
//  Created by Дарья on 08.11.2026.
//

import Foundation

protocol AuthViewInput: AnyObject {
    func showLoading(_ isLoading: Bool)
    func showError(with message: String)
    func didAuthorize()
}

protocol AuthViewHandler {
    func login(with email: String, password: String)
    func register(with email: String, password: String, name: String)
}

final class AuthPresenter: AuthViewHandler {

    weak var view: AuthViewInput?
    private let auth: AuthServiceable
    private let storage: StorageServiceable

    init(auth: AuthServiceable, storage: StorageServiceable) {
        self.auth = auth
        self.storage = storage
    }

    func login(with email: String, password: String) {
        let email = normalize(email)

        guard email.contains("@"), password.count >= 6 else {
            view?.showError(with: "Введите почту и пароль от 6 символов")
            return
        }

        view?.showLoading(true)

        auth.login(with: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                self?.handle(result)
            }
        }
    }

    func register(with email: String, password: String, name: String) {
        let email = normalize(email)
        let name = name.trimmingCharacters(in: .whitespacesAndNewlines)

        guard name.count >= 2 else {
            view?.showError(with: "Введите имя")
            return
        }

        guard email.contains("@"), password.count >= 6 else {
            view?.showError(with: "Введите почту и пароль от 6 символов")
            return
        }

        view?.showLoading(true)

        auth.register(with: email, password: password, name: name) { [weak self] result in
            DispatchQueue.main.async {
                self?.handle(result)
            }
        }
    }

    private func handle(_ result: Result<AppUser, NetworkError>) {
        view?.showLoading(false)

        switch result {
        case .success(let user):
            storage.saveUser(user)
            view?.didAuthorize()

        case .failure:
            view?.showError(with: "Не удалось выполнить вход. Проверьте данные и интернет")
        }
    }

    private func normalize(_ email: String) -> String {
        email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }
}
