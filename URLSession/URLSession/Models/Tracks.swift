//
//  Tracks.swift
//  URLSession
//
//  Created by pro648 on 2019/8/29.
//  Copyright © 2019 pro648. All rights reserved.
//

import Foundation

class Track {
    // MARK: - Constants
    let artist: String
    let index: Int
    let name: String
    let previewURL: URL
    
    // MARK: - Variables and Properties
    var downloaded = false
    
    // MARK: - Initialization
    init(name: String, artist: String, previewURL: URL, index: Int) {
        self.name = name
        self.artist = artist
        self.previewURL = previewURL
        self.index = index
    }
}
