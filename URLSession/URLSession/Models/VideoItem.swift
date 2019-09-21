//
//  VideoItem.swift
//  URLSession
//
//  Created by pro648 on 2019/8/29.
//  Copyright © 2019 pro648. All rights reserved.
//

import Foundation

class VideoItem: Codable {
    
    let remoteURL: URL
    let filePathURL: URL
    var resumeData: Data
    
    private enum CodingKeys: String, CodingKey {
        case remoteURL
        case filePathURL
        case resumeData
    }
    
    // MARK: - Init
    init(remoteURL: URL, resumeData: Data?) {
        self.remoteURL = remoteURL
        self.filePathURL = RetrieveCacheURL.cacheFileURL(sourceURL: remoteURL)
        self.resumeData = resumeData ?? Data()
    }
}
