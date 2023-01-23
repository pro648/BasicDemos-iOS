//
//  ImageCache.swift
//  NSCache
//
//  Created by ad on 2023/1/23.
//

import UIKit

struct ImageCache {
    static let shared = ImageCache()
    
    let cache = NSCache<NSString, UIImage>()
    
    init() {
        cache.countLimit = 10
        cache.totalCostLimit = 50_000_000
    }
}
