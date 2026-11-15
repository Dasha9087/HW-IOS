//
//  ProfilePresenter.swift
//  DiplomSerova1
//
//  Created by Дарья on 08.11.2026.
//

import Foundation

protocol ProfileViewInput: AnyObject {
    func modelUpdated(user: AppUser)
    func clearProfile()
    func modelUpdated(ads: [Ad])
    func removeMyAd(id: String)
    func showLoading(_ isLoading: Bool)
    func showEmptyState(message: String?)
    func showError(with message: String)
    func didSignOut()
}

protocol ProfileViewHandler {
    func fetchUser()
    func signOut()
    func deleteAd(_ ad: Ad)
}

final class ProfilePresenter: ProfileViewHandler {
    weak var view: ProfileViewInput?

    private let adsService: AdsServiceable
    private let authService: AuthServiceable

    private var isLoadingAds = false
    private var deletingAdIDs: Set<String> = []

    init(
        adsService: AdsServiceable,
        authService: AuthServiceable
    ) {
        self.adsService = adsService
        self.authService = authService
    }

    func fetchUser() {
        guard let userId = authService.currentUserId else {
            view?.clearProfile()
            view?.modelUpdated(ads: [])
            view?.showLoading(false)
            view?.showEmptyState(
                message: "Войдите в аккаунт, чтобы увидеть свои объявления."
            )
            return
        }

        if let cachedUser = StorageService.shared.getUser(),
           cachedUser.id == userId {
            view?.modelUpdated(user: cachedUser)
        }

        loadProfile()
        loadMyAds(userId: userId)
    }

    func signOut() {
        do {
            try authService.signOut()
            StorageService.shared.clearSession()

            view?.clearProfile()
            view?.modelUpdated(ads: [])
            view?.didSignOut()
        } catch {
            view?.showError(
                with: "Не удалось выйти из аккаунта: \(error.localizedDescription)"
            )
        }
    }

    func deleteAd(_ ad: Ad) {
        guard let userId = authService.currentUserId else {
            view?.showError(with: "Войдите в аккаунт, чтобы удалить объявление.")
            return
        }

        guard ad.userId == userId else {
            view?.showError(with: "Можно удалять только свои объявления.")
            return
        }

        guard !deletingAdIDs.contains(ad.id) else { return }
        deletingAdIDs.insert(ad.id)

        adsService.deleteAd(adId: ad.id, userId: userId) { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }

                self.deletingAdIDs.remove(ad.id)

                guard self.authService.currentUserId == userId else { return }

                switch result {
                case .success:
                    self.view?.removeMyAd(id: ad.id)

                case .failure(let error):
                    self.view?.showError(
                        with: "Не удалось удалить объявление: "
                        + error.localizedDescription
                    )
                }
            }
        }
    }

    private func loadProfile() {
        authService.fetchUser { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }

                switch result {
                case .success(let user):
                    guard self.authService.currentUserId == user.id else { return }

                    StorageService.shared.saveUser(user)
                    self.view?.modelUpdated(user: user)

                case .failure(let error):
                    let hasCachedUser =
                        StorageService.shared.getUser()?.id
                        == self.authService.currentUserId

                    if !hasCachedUser {
                        self.view?.showError(
                            with: "Не удалось загрузить профиль: "
                            + error.localizedDescription
                        )
                    }
                }
            }
        }
    }

    private func loadMyAds(userId: String) {
        guard !isLoadingAds else { return }

        isLoadingAds = true
        view?.showEmptyState(message: nil)
        view?.showLoading(true)

        adsService.fetchMyAds(userId: userId) { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }

                self.isLoadingAds = false
                self.view?.showLoading(false)

                // Не показываем результат старого запроса после выхода из аккаунта.
                guard self.authService.currentUserId == userId else { return }

                switch result {
                case .success(let ads):
                    self.view?.modelUpdated(ads: ads)
                    self.view?.showEmptyState(
                        message: ads.isEmpty
                            ? "У вас пока нет объявлений."
                            : nil
                    )

                case .failure(let error):
                    self.view?.modelUpdated(ads: [])
                    self.view?.showEmptyState(
                        message: "Не удалось загрузить ваши объявления."
                    )
                    self.view?.showError(
                        with: "Ошибка загрузки объявлений: "
                        + error.localizedDescription
                    )
                }
            }
        }
    }
}
