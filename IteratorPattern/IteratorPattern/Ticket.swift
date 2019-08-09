//
//  Ticket.swift
//  IteratorPattern
//
//  Created by pro648 on 2019/8/2.
//  Copyright © 2019 pro648. All rights reserved.
//

import Foundation

public struct Ticket {
    var description: String
    var priority: PriorityType
    
    enum PriorityType {
        case low
        case medium
        case high
    }
    
    init(description: String, priority: PriorityType) {
        self.description = description
        self.priority = priority
    }
}

extension Ticket {
    var sortIndex: Int {
        switch self.priority {
        case .low:
            return 0
        case .medium:
            return 1
        case .high:
            return 2
        }
    }
}
