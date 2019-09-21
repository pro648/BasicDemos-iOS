//
//  VideoCell.swift
//  URLSession
//
//  Created by pro648 on 2019/9/12.
//  Copyright © 2019 pro648. All rights reserved.
//

import UIKit

// MARK: - Video Cell Delegate protocol

protocol VideoCellDelegate {
    func downloadTapped(_ cell: VideoCell)
}

// MARK: - Video Cell

class VideoCell: UITableViewCell {
    
    // MARK: - Class Constants
    static let identifier = "VideoCell"
    
    // MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    
    // MARK: - Variables And Properties
    var delegate: VideoCellDelegate?
    
    // MARK: - IBActions
    @IBAction func downloadTapped(_ sender: UIButton) {
        if sender.currentTitle == "Download" {
            delegate?.downloadTapped(self)
            sender.setTitle("Downloading", for: .normal)
        }
    }
    
    func configureVideoCell(track: Track) {
        titleLabel.text = track.name
        artistLabel.text = track.artist
    }
}
