//
//  SearchViewController.swift
//  URLSession
//
//  Created by pro648 on 2019/8/29.
//  Copyright © 2019 pro648. All rights reserved.


//  详细介绍：https://github.com/pro648/tips/wiki/URLSession%E8%AF%A6%E8%A7%A3

import Foundation
import AVKit
import UIKit
import Photos

class SearchViewController: UIViewController {
    
    let downloadService = DownloadService()
    let queryService = QueryService()
    
    // MARK: - IBOutlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Variables And Properties
    lazy var downloadsSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        
        configuration.timeoutIntervalForResource = 300
        configuration.waitsForConnectivity = true
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()
    
    var searchResults: [Track] = []
    
    lazy var tapRecognizer: UITapGestureRecognizer = {
        var recognizer = UITapGestureRecognizer(target: self,
                                                action: #selector(dismissKeyboard))
        return recognizer
    }()
    
    // MARK: - Internal Methods
    @objc func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
    
    func playDownload(_ track: Track) {
        let playerViewController = AVPlayerViewController()
        present(playerViewController,
                animated: true,
                completion: nil)
        
        let url = RetrieveCacheURL.cacheFileURL(sourceURL: track.previewURL)
        let player = AVPlayer(url: url)
        playerViewController.player = player
        player.play()
    }
    
    func position(for bar: UIBarPosition) -> UIBarPosition {
        return .topAttached
    }
    
    func reload(_ row: Int) {
        tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .automatic)
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        downloadService.downloadsSession = downloadsSession
    }
}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
        
        guard let searchText = searchBar.text,
            !searchText.isEmpty else { return }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        queryService.getSearchResult(searchTerm: searchText) { [weak self] (results, errorMessage) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            if let results = results {
                self?.searchResults = results
                self?.tableView.reloadData()
                self?.tableView.setContentOffset(CGPoint.zero, animated: false)
            }
            
            if !errorMessage.isEmpty {
                print("Search error: " + errorMessage)
            }
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        view.addGestureRecognizer(tapRecognizer)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        view.removeGestureRecognizer(tapRecognizer)
    }
}

// MARK: - Table View Data Source

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TrackCell = tableView.dequeueReusableCell(withIdentifier: TrackCell.identifier,
                                                            for: indexPath) as! TrackCell
        
        // Delegate cell button tap events to this view controller.
        cell.delegate = self as TrackCellDelegate
        
        let track = searchResults[indexPath.row]
        cell.configure(track: track,
                       downloaded: track.downloaded,
                       download: downloadService.activeDownloads[track.previewURL])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
}

// MARK: - UITableViewDelegate

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // When user taps cell, play the local file, if it's downloaded.
        
        let track = searchResults[indexPath.row]
        
        if track.downloaded {
            playDownload(track)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - TrackCellDelegate

extension SearchViewController: TrackCellDelegate {
    func cancelTapped(_ cell: TrackCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let track = searchResults[indexPath.row]
            downloadService.cancelDownload(track)
            reload(indexPath.row)
        }
    }
    
    func downloadTapped(_ cell: TrackCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let track = searchResults[indexPath.row]
            downloadService.startDownload(track)
            reload(indexPath.row)
        }
    }
    
    func pauseTapped(_ cell: TrackCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let track = searchResults[indexPath.row]
            downloadService.pauseDownload(track)
            reload(indexPath.row)
        }
    }
    
    func resumeTapped(_ cell: TrackCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let track = searchResults[indexPath.row]
            downloadService.resumeDownload(track)
            reload(indexPath.row)
        }
    }
}

// MARK: - URLSessionDownloadDelegate
extension SearchViewController: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let httpURLResponse = downloadTask.response as? HTTPURLResponse,
            (200...299).contains(httpURLResponse.statusCode) else {
                print("Status Code")
                return
        }
        
        guard let sourceURL = downloadTask.currentRequest?.url else { return }
        
        let download = downloadService.activeDownloads[sourceURL]
        downloadService.activeDownloads[sourceURL] = nil
        
        let destinationURL = RetrieveCacheURL.cacheFileURL(sourceURL: sourceURL)
        print(destinationURL)
        
        let fileManager = FileManager.default
        try? fileManager.removeItem(at: destinationURL)
        
        do {
            try fileManager.copyItem(at: location, to: destinationURL)
            download?.track.downloaded = true
        } catch let error {
            print("Could not copy file to disk: \(error.localizedDescription)")
        }
        
        if let index = download?.track.index {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
            }
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        guard let url = downloadTask.currentRequest?.url,
            let download = downloadService.activeDownloads[url] else {
                return
        }
        
        download.progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        let totalSize = ByteCountFormatter.string(fromByteCount: totalBytesExpectedToWrite, countStyle: .file)
        
        DispatchQueue.main.async {
            if let trackCell = self.tableView.cellForRow(at: IndexPath(row: download.track.index,
                                                                       section: 0)) as? TrackCell {
                trackCell.updateDisplay(progress: download.progress, totalSize: totalSize)
            }
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        print("fileOffset: \(fileOffset) \(expectedTotalBytes)")
    }
}

// MARK: - URLSessionTaskDelegate
extension SearchViewController: URLSessionTaskDelegate {
    func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
        completionHandler(request)
    }
    
    @available(iOS 11.0, *)
    func urlSession(_ session: URLSession, taskIsWaitingForConnectivity task: URLSessionTask) {
        // Waiting for connectivity, update UI, etc.
        print(task.currentRequest?.url?.absoluteString ?? "")
    }
    
    @available(iOS 10.0, *)
    func urlSession(_ session: URLSession, task: URLSessionTask, didFinishCollecting metrics: URLSessionTaskMetrics) {
        print("metrics: \(metrics.transactionMetrics)")
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        guard let error = error else {
            // Handle success case.
            return
        }
        
        let userInfo = (error as NSError).userInfo
        if userInfo[NSLocalizedDescriptionKey] as? String == "cancelled" {  // 手动取消的下载不需要保存
            return
        }
        
        if let resumeData = userInfo[NSURLSessionDownloadTaskResumeData] as? Data,
            let sourceURL = task.currentRequest?.url,
            let download = downloadService.activeDownloads[sourceURL]
            {
            download.resumeData = resumeData
            download.isDownloading = false
            
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadRows(at: [IndexPath(row: download.track.index, section: 0)], with: .automatic)
            }
        }
    }
}
