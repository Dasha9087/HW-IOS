//
//  AdsServiceable.swift
//  DiplomSerova1
//
//  Created by Дарья on 08.11.2026.
//

import Foundation

protocol AdsServiceable {
    func resetPagination()

    func fetchNextAds(
        limit: Int,
        completion: @escaping (Result<[Ad], NetworkError>) -> Void
    )

    func createAd(
        title: String,
        description: String,
        price: Int,
        category: String,
        city: String,
        userId: String,
        completion: @escaping (Result<Void, NetworkError>) -> Void
    )

    func deleteAd(
        adId: String,
        userId: String,
        completion: @escaping (Result<Void, NetworkError>) -> Void
    )

    func fetchMyAds(
        userId: String,
        completion: @escaping (Result<[Ad], NetworkError>) -> Void
    )

    func fetchFavorites(
        userId: String,
        completion: @escaping (Result<[Ad], NetworkError>) -> Void
    )

    func addFavorite(
        _ ad: Ad,
        userId: String,
        completion: @escaping (Result<Void, NetworkError>) -> Void
    )

    func removeFavorite(
        adId: String,
        userId: String,
        completion: @escaping (Result<Void, NetworkError>) -> Void
    )
}
