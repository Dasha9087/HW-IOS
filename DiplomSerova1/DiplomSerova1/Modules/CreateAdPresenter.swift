//
//  CreateAdPresenter.swift
//  DiplomSerova1
//
//  Created by Дарья on 08.11.2026.
//

import Foundation

protocol CreateAdViewInput: AnyObject {
    func showLoading(_ isLoading: Bool)
    func modelUpdated(category: AdCategory?)
    func showError(with message: String)
    func didCreateAd()
}

protocol CreateAdViewHandler {
    func selectCategory(_ category: AdCategory?)
    func createAd(title: String, description: String, price: String, city: String)
}

final class CreateAdPresenter: CreateAdViewHandler {
    weak var view: CreateAdViewInput?

    private let adsService: AdsServiceable
    private let authService: AuthServiceable

    private var selectedCategory: AdCategory?
    private var isCreating = false

    init(
        adsService: AdsServiceable,
        authService: AuthServiceable
    ) {
        self.adsService = adsService
        self.authService = authService
    }

    func selectCategory(_ category: AdCategory?) {
        selectedCategory = category
        view?.modelUpdated(category: category)
    }

    func createAd(
        title: String,
        description: String,
        price: String,
        city: String
    ) {
        guard !isCreating else { return }

        guard let userId = authService.currentUserId else {
            view?.showError(with: "Чтобы разместить объявление, войдите в аккаунт.")
            return
        }

        let cleanTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanDescription = description.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanCity = city.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !cleanTitle.isEmpty else {
            view?.showError(with: "Введите название объявления.")
            return
        }

        guard !cleanDescription.isEmpty else {
            view?.showError(with: "Введите описание объявления.")
            return
        }

        guard !cleanCity.isEmpty else {
            view?.showError(with: "Введите город.")
            return
        }

        guard let category = selectedCategory else {
            view?.showError(with: "Выберите категорию объявления.")
            return
        }

        let normalizedPrice = price
            .components(separatedBy: .whitespacesAndNewlines)
            .joined()

        guard let priceValue = Int(normalizedPrice), priceValue > 0 else {
            view?.showError(
                with: "Введите целую цену числом больше нуля, например: 1200."
            )
            return
        }

        isCreating = true
        view?.showLoading(true)

        adsService.createAd(
            title: cleanTitle,
            description: cleanDescription,
            price: priceValue,
            category: category.rawValue,
            city: cleanCity,
            userId: userId
        ) { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }

                self.isCreating = false
                self.view?.showLoading(false)

                switch result {
                case .success:
                    self.selectedCategory = nil
                    self.view?.modelUpdated(category: nil)
                    self.view?.didCreateAd()

                case .failure(let error):
                    self.view?.showError(
                        with: "Не удалось разместить объявление: "
                        + error.localizedDescription
                    )
                }
            }
        }
    }
}
