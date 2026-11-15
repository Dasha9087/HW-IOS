//
//  CatalogPresenter.swift
//  DiplomSerova1
//
//  Created by Дарья on 08.11.2026.
//

import Foundation

protocol CatalogViewInput: AnyObject {
    func modelUpdated(ads: [Ad])
    func showHistory(_ items: [String])
    func showLoading(_ isLoading: Bool)
    func showPageLoading(_ isLoading: Bool)
    func showError(with message: String)
}

protocol CatalogViewHandler {
    func fetchAds()
    func loadFirst()
    func loadNext()
    func updateTitle(_ text: String)
    func submitSearch(_ text: String)
    func updateCategory(_ category: AdCategory?)
    func updatePrice(min: String, max: String)
    func clearHistory()
}

final class CatalogPresenter: CatalogViewHandler {

    weak var view: CatalogViewInput?

    private let service: AdsServiceable
    private let auth: AuthServiceable
    private let storage: StorageServiceable

    private var allAds: [Ad] = []
    private var filter = AdFilter()
    private var isLoading = false
    private var canLoadMore = true

    init(
        service: AdsServiceable,
        auth: AuthServiceable,
        storage: StorageServiceable
    ) {
        self.service = service
        self.auth = auth
        self.storage = storage
    }

    func fetchAds() {
        view?.showHistory(storage.getSearchHistory())
        loadFirst()
    }

    func loadFirst() {
        guard auth.currentUserId != nil else { return }
        guard !isLoading else { return }

        isLoading = true
        canLoadMore = true
        service.resetPagination()
        view?.showLoading(true)

        request(reset: true)
    }

    func loadNext() {
        guard auth.currentUserId != nil,
              !isLoading,
              canLoadMore else {
            return
        }

        isLoading = true
        view?.showPageLoading(true)

        request(reset: false)
    }

    func updateTitle(_ text: String) {
        filter.title = text
        applyFilter()
    }

    func submitSearch(_ text: String) {
        let clean = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !clean.isEmpty else { return }

        storage.addSearch(clean)
        view?.showHistory(storage.getSearchHistory())
    }

    func updateCategory(_ category: AdCategory?) {
        filter.category = category
        applyFilter()
    }

    func updatePrice(min: String, max: String) {
        filter.minPrice = Int(min)
        filter.maxPrice = Int(max)
        applyFilter()
    }

    func clearHistory() {
        storage.clearHistory()
        view?.showHistory([])
    }

    private func request(reset: Bool) {
        service.fetchNextAds(limit: 10) { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }

                self.isLoading = false
                self.view?.showLoading(false)
                self.view?.showPageLoading(false)

                switch result {
                case .success(let ads):
                    if reset {
                        self.allAds = ads
                    } else {
                        self.allAds.append(contentsOf: ads)
                    }

                    self.canLoadMore = ads.count == 10
                    self.applyFilter()

                case .failure:
                    self.view?.showError(with: "Не удалось загрузить объявления")
                }
            }
        }
    }

    private func applyFilter() {
        let title = filter.title
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()

        let result = allAds.filter { ad in
            let titlePassed = title.isEmpty ||
                ad.title.lowercased().contains(title)

            let categoryPassed = filter.category == nil ||
                ad.category == filter.category?.rawValue

            let minPassed = filter.minPrice == nil ||
                ad.price >= (filter.minPrice ?? 0)

            let maxPassed = filter.maxPrice == nil ||
                ad.price <= (filter.maxPrice ?? Int.max)

            return titlePassed && categoryPassed && minPassed && maxPassed
        }

        view?.modelUpdated(ads: result)
    }
}

private struct AdFilter {
    var title = ""
    var category: AdCategory?
    var minPrice: Int?
    var maxPrice: Int?
}
