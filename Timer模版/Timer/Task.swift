//
//  Task.swift
//  Timer
//
//  Created by pro648 on 2020/1/19.
//  Copyright © 2020 pro648. All rights reserved.
//

import Foundation

class Task {
    let name: String
    let creationDate = Date()
    var completed = false
    
    init(name: String) {
        self.name = name
    }
}
