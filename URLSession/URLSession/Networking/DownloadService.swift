//
//  DownloadService.swift
//  URLSession
//
//  Created by pro648 on 2019/8/29.
//  Copyright © 2019 pro648. All rights reserved.
//

import Foundation

// MARK: - Download Service

/// Downloads song snippets, and stores in local file.
/// Allows cancel, pause, resume download.
class DownloadService {
    
    // MARK: - Variables And Properties
    
    var activeDownloads: [URL: MusicItem] = [:]
    var downloadsSession: URLSession!
    
    // MARK: - Internal Methods
    
    func cancelDownload(_ track: Track) {
        guard let download = activeDownloads[track.previewURL] else { return }
        download.task?.cancel()
        
        activeDownloads[track.previewURL] = nil
    }
    
    func pauseDownload(_ track: Track) {
        guard let download = activeDownloads[track.previewURL],
            download.isDownloading else { return }
        
        download.task?.cancel(byProducingResumeData: { (data) in
            download.resumeData = data
        })
        
        download.isDownloading = false
    }
    
    func resumeDownload(_ track: Track) {
        guard let download = activeDownloads[track.previewURL] else { return }
        
        if let resumeData = download.resumeData {
            download.task = downloadsSession.downloadTask(withResumeData: resumeData)
        } else {
            download.task = downloadsSession.downloadTask(with: download.track.previewURL)
        }
        
        download.task?.resume()
        download.isDownloading = true
    }
    
    func startDownload(_ track: Track) {
        let download = MusicItem(track: track)
        download.task = downloadsSession.downloadTask(with: track.previewURL)
        download.task?.resume()
        download.isDownloading = true
        activeDownloads[download.track.previewURL] = download
    }
}
