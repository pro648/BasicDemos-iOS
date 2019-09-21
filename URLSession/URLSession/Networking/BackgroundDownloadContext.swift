//
//  BackgroundDownloadContext.swift
//  URLSession
//
//  Created by pro648 on 2019/8/29.
//  Copyright © 2019 pro648. All rights reserved.
//

import Foundation

class BackgroundDownloadContext {
    
    private var inMemoryDownloadVideos: [URL: VideoItem] = [:]
    private let userDefaults = UserDefaults.standard
    
    // MARK: - Load
    func loadVideoItem(withURL url: URL) -> VideoItem? {
        if let videoItem = inMemoryDownloadVideos[url] {
            return videoItem
        } else if let videoItem = loadVideoItemFromStorage(withURL: url) {
            inMemoryDownloadVideos[videoItem.remoteURL] = videoItem
            
            return videoItem
        }
        
        return nil
    }
    
    private func loadVideoItemFromStorage(withURL url: URL) -> VideoItem? {
        guard let encodedData = userDefaults.object(forKey: url.path) as? Data else { return nil }
        
        let videoItem = try? JSONDecoder().decode(VideoItem.self, from: encodedData)
        return videoItem
    }
    
    // MARK: - Save
    func saveVideoItem(_ videoItem: VideoItem) {
        inMemoryDownloadVideos[videoItem.remoteURL] = videoItem
        
        let encodedData = try? JSONEncoder().encode(videoItem)
        userDefaults.set(encodedData, forKey: videoItem.remoteURL.path)
    }
    
    // MARK: - Delete
    func deleteVideoItem(_ videoItem: VideoItem) -> Void {
        inMemoryDownloadVideos[videoItem.remoteURL] = nil
        userDefaults.removeObject(forKey: videoItem.remoteURL.path)
    }
}
