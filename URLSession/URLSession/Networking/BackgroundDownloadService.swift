//
//  BackgroundDownloadService.swift
//  URLSession
//
//  Created by pro648 on 2019/8/29.
//  Copyright © 2019 pro648. All rights reserved.
//

import Foundation
import Photos

class BackgroundDownloadService: NSObject {
    
    var backgroundCompletionHandler: (() -> Void)?
    
    private let context = BackgroundDownloadContext()
    
    lazy var backgroundDownloadSession: URLSession = {
        let configuration = URLSessionConfiguration.background(withIdentifier: "github.com/pro648")
        configuration.isDiscretionary = true
        configuration.sessionSendsLaunchEvents = true
        return URLSession(configuration: configuration,
                          delegate: self,
                          delegateQueue: nil)
    }()
    
    // MARK: - Singleton
    static let shared = BackgroundDownloadService()
    
    // MARK: - Download
    
    func download(remoteURL: URL) {
        print("Scheduling to download: \(remoteURL)")
        
        let videoItem = VideoItem(remoteURL: remoteURL, resumeData: nil)
        context.saveVideoItem(videoItem)
        
        let task = backgroundDownloadSession.downloadTask(with: remoteURL)
        task.earliestBeginDate = Date().addingTimeInterval(15)  // Added a delay for demonstration purposes only
        task.countOfBytesClientExpectsToSend = 3 * 1024
        task.countOfBytesClientExpectsToReceive = 60 * 1024 * 1024
        task.resume()
    }
}

// MARK: - URLSessionDelegate
extension BackgroundDownloadService: URLSessionDelegate {
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        DispatchQueue.main.async {
            self.backgroundCompletionHandler?()
            self.backgroundCompletionHandler = nil
        }
    }
}

// MARK: - URLSessionDownloadDelegate

extension BackgroundDownloadService: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let httpURLResponse = downloadTask.response as? HTTPURLResponse,
        (200...299).contains(httpURLResponse.statusCode) else {
            print("Status Code Error")
            return
        }
        
        guard let sourceURL = downloadTask.currentRequest?.url,
        let videoItem = context.loadVideoItem(withURL: sourceURL) else {
            return
        }
        
        print("Downloaded: \(videoItem.remoteURL)")
        
        do {
            try FileManager.default.moveItem(at: location, to: videoItem.filePathURL)
            
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: videoItem.filePathURL)
            }) { (success, error) in
                if error != nil {
                    print("Save failed")
                } else {
                    print("Save success")
                }
            }
        } catch {
            print("Failed move item to \(videoItem.filePathURL)")
        }
        
        context.deleteVideoItem(videoItem)
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        print("fileOffset: \(fileOffset) \(expectedTotalBytes)")
    }
}

extension BackgroundDownloadService: URLSessionTaskDelegate {
    @available(iOS 11.0, *)
    func urlSession(_ session: URLSession, task: URLSessionTask, willBeginDelayedRequest request: URLRequest, completionHandler: @escaping (URLSession.DelayedRequestDisposition, URLRequest?) -> Void) {
        completionHandler(.continueLoading, nil)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        guard let error = error else {
            // Handle success case.
            return
        }
        
        let userInfo = (error as NSError).userInfo
        
        if let resumeData = userInfo[NSURLSessionDownloadTaskResumeData] as? Data,
            let sourceURL = task.currentRequest?.url,
            let videoItem = context.loadVideoItem(withURL: sourceURL)
        {
            videoItem.resumeData = resumeData
            
            // 恢复上次手动取消的任务
            let task = backgroundDownloadSession.downloadTask(withResumeData: resumeData)
            task.resume()
        }
    }
}
