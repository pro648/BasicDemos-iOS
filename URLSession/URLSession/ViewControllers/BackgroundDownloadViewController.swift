//
//  BackgroundDownloadViewController.swift
//  URLSession
//
//  Created by pro648 on 2019/8/29.
//  Copyright © 2019 pro648. All rights reserved.
//

import Foundation
import UIKit
import Photos

class BackgroundDownloadViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    private var results: [Track] = []
    private let queryService = QueryService()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        
        // 后台下载视频
        if let jsonURL = Bundle.main.url(forResource: "media", withExtension: "json") {
            loadJSONAssetWithURL(jsonURL: jsonURL)
        }
        
        PHPhotoLibrary.requestAuthorization { (status) in
            
        }
    }
    
    private func loadJSONAssetWithURL(jsonURL: URL) {
        var data = Data()
        do {
            try data = Data(contentsOf: jsonURL)
        } catch {
            print("Failed retreve json data")
        }
        
        queryService.updateSearchResults(data)
        results = queryService.tracks
        
        tableView.reloadData()
    }
    
    // MARK: - IBAction
    @IBAction func crash(_ sender: Any) {
        exit(0)
    }
}

extension BackgroundDownloadViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: VideoCell = tableView.dequeueReusableCell(withIdentifier: VideoCell.identifier, for: indexPath) as! VideoCell
        
        cell.delegate = self as VideoCellDelegate
        
        let track = results[indexPath.row]
        cell.configureVideoCell(track: track)
        
        return cell
    }
}

extension BackgroundDownloadViewController: VideoCellDelegate {
    func downloadTapped(_ cell: VideoCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let track = results[indexPath.row]
            BackgroundDownloadService.shared.download(remoteURL: track.previewURL)
        }
    }
}
