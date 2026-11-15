//
//  AdDetailsPresenter.swift
//  DiplomSerova1
//
//  Created by Дарья on 08.11.2026.
//

import Foundation

struct AdDetailsViewModel {
    let title: String
    let price: String
    let category: String
    let city: String
    let descriptionText: String
    let dateText: String
}

protocol AdDetailsViewInput: AnyObject {
    func modelUpdated(model: AdDetailsViewModel)
    func setFavoriteButton(isFavorite: Bool, isEnabled: Bool)
    func showError(with message: String)
}

protocol AdDetailsViewHandler {
    func fetchAd()
    func favoriteButtonTapped()
}

final class AdDetailsPresenter: AdDetailsViewHandler {
    weak var view: AdDetailsViewInput?

    private let ad: Ad
    private let adsService: AdsServiceable
    private let authService: AuthServiceable

    private var isFavorite = false
    private var isUpdatingFavorite = false

    init(
        ad: Ad,
        adsService: AdsServiceable,
        authService: AuthServiceable
    ) {
        self.ad = ad
        self.adsService = adsService
        self.authService = authService
    }

    func fetchAd() {
        view?.modelUpdated(model: makeViewModel())
        view?.setFavoriteButton(isFavorite: false, isEnabled: true)
        loadFavoriteState()
    }

    func favoriteButtonTapped() {
        guard let userId = authService.currentUserId else {
            view?.showError(with: "Чтобы добавить объявление в избранное, войдите в аккаунт.")
            return
        }

        guard !isUpdatingFavorite else { return }

        isUpdatingFavorite = true
        view?.setFavoriteButton(isFavorite: isFavorite, isEnabled: false)

        if isFavorite {
            adsService.removeFavorite(adId: ad.id, userId: userId) { [weak self] result in
                self?.finishFavoriteUpdate(result, isFavorite: false)
            }
        } else {
            adsService.addFavorite(ad, userId: userId) { [weak self] result in
                self?.finishFavoriteUpdate(result, isFavorite: true)
            }
        }
    }

    private func loadFavoriteState() {
        guard let userId = authService.currentUserId else { return }

        adsService.fetchFavorites(userId: userId) { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }

                switch result {
                case .success(let ads):
                    self.isFavorite = ads.contains { $0.id == self.ad.id }
                    self.view?.setFavoriteButton(
                        isFavorite: self.isFavorite,
                        isEnabled: true
                    )

                case .failure(let error):
                    self.view?.showError(
                        with: "Не удалось загрузить избранное: \(error.localizedDescription)"
                    )
                }
            }
        }
    }

    private func finishFavoriteUpdate(
        _ result: Result<Void, NetworkError>,
        isFavorite newValue: Bool
    ) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }

            self.isUpdatingFavorite = false

            switch result {
            case .success:
                self.isFavorite = newValue
                self.view?.setFavoriteButton(
                    isFavorite: newValue,
                    isEnabled: true
                )

            case .failure(let error):
                self.view?.setFavoriteButton(
                    isFavorite: self.isFavorite,
                    isEnabled: true
                )
                self.view?.showError(with: error.localizedDescription)
            }
        }
    }

    private func makeViewModel() -> AdDetailsViewModel {
        AdDetailsViewModel(
            title: ad.title,
            price: AdFormatter.price(ad.price),
            category: ad.category,
            city: ad.city.isEmpty ? "Не указан" : ad.city,
            descriptionText: ad.description.isEmpty
                ? "Описание не указано"
                : ad.description,
            dateText: "Опубликовано: \(AdFormatter.date(ad.createdAt))"
        )
    }
}
