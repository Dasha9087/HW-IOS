//
//  FavoritesPresenter.swift
//  DiplomSerova1
//
//  Created by Дарья on 08.11.2026.
//

import Foundation

protocol FavoritesViewInput: AnyObject {
    func modelUpdated(ads: [Ad])
    func showLoading(_ isLoading: Bool)
    func showEmptyState(message: String?)
    func showError(with message: String)
}

protocol FavoritesViewHandler {
    func fetchFavorites()
    func removeFavorite(at index: Int)
}

final class FavoritesPresenter: FavoritesViewHandler {
    weak var view: FavoritesViewInput?

    private let adsService: AdsServiceable
    private let authService: AuthServiceable

    private var favoriteAds: [Ad] = []
    private var isLoading = false
    private var removingAdIDs = Set<String>()

    init(
        adsService: AdsServiceable,
        authService: AuthServiceable
    ) {
        self.adsService = adsService
        self.authService = authService
    }

    func fetchFavorites() {
        loadFavorites()
    }

    func removeFavorite(at index: Int) {
        guard
            let userId = authService.currentUserId,
            favoriteAds.indices.contains(index)
        else {
            return
        }

        let ad = favoriteAds[index]

        guard !removingAdIDs.contains(ad.id) else { return }
        removingAdIDs.insert(ad.id)

        adsService.removeFavorite(adId: ad.id, userId: userId) { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }

                self.removingAdIDs.remove(ad.id)

                switch result {
                case .success:
                    self.favoriteAds.removeAll { $0.id == ad.id }
                    self.view?.modelUpdated(ads: self.favoriteAds)
                    self.updateEmptyState()

                case .failure(let error):
                    self.view?.showError(
                        with: "Не удалось удалить объявление из избранного: "
                        + error.localizedDescription
                    )
                }
            }
        }
    }

    private func loadFavorites() {
        guard let userId = authService.currentUserId else {
            favoriteAds = []
            view?.modelUpdated(ads: [])
            view?.showLoading(false)
            view?.showEmptyState(
                message: "Войдите в аккаунт, чтобы увидеть избранное."
            )
            return
        }

        guard !isLoading else { return }

        isLoading = true
        view?.showEmptyState(message: nil)
        view?.showLoading(true)

        adsService.fetchFavorites(userId: userId) { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }

                self.isLoading = false
                self.view?.showLoading(false)

                switch result {
                case .success(let ads):
                    self.favoriteAds = ads
                    self.view?.modelUpdated(ads: ads)
                    self.updateEmptyState()

                case .failure(let error):
                    self.favoriteAds = []
                    self.view?.modelUpdated(ads: [])
                    self.view?.showEmptyState(
                        message: "Не удалось загрузить избранное."
                    )
                    self.view?.showError(
                        with: "Ошибка загрузки избранного: "
                        + error.localizedDescription
                    )
                }
            }
        }
    }

    private func updateEmptyState() {
        if favoriteAds.isEmpty {
            view?.showEmptyState(
                message: "В избранном пока нет объявлений."
            )
        } else {
            view?.showEmptyState(message: nil)
        }
    }
}
