//
//  Monster.swift
//  PrototypePattern
//
//  Created by pro648 on 2019/8/13.
//  Copyright © 2019 pro648. All rights reserved.
//

import Foundation

// Monster 类遵守 Copying 协议
public class Monster: Copying {
    public var health: Int
    public var level: Int
    
    public init(health: Int, level: Int) {
        self.health = health
        self.level = level
    }
    
    public required convenience init(_ monster: Monster) {
        self.init(health: monster.health, level: monster.level)
    }
}

extension Array where Element: Copying {
    public func deepCopy() -> [Element] {
        return map { $0.copy() }
    }
}
