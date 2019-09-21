//
//  RetrieveCacheURL.swift
//  URLSession
//
//  Created by pro648 on 2019/9/12.
//  Copyright © 2019 pro648. All rights reserved.
//

import Foundation

class RetrieveCacheURL {
    class func cacheFileURL(sourceURL url: URL) -> URL {
        let cacheURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        return cacheURL.appendingPathComponent(url.lastPathComponent)
    }
}
