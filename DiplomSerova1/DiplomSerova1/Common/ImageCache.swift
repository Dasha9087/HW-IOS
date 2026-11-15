//
//  ImageCache.swift
//  DiplomSerova1
//
//  Created by Дарья on 08.11.2026.
//

import UIKit

final class ImageCache {

    static let shared = ImageCache()
    private let cache = NSCache<NSString, UIImage>()

    private init() {}

    func image(named systemName: String) -> UIImage? {
        let key = systemName as NSString

        if let cachedImage = cache.object(forKey: key) {
            return cachedImage
        }

        guard let image = UIImage(systemName: systemName) else {
            return nil
        }

        cache.setObject(image, forKey: key)
        return image
    }
}
