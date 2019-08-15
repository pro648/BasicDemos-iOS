//
//  EyeballMonster.swift
//  PrototypePattern
//
//  Created by pro648 on 2019/8/14.
//  Copyright © 2019 pro648. All rights reserved.
//

import Foundation

// EyeballMonster 为 Monster 子类，同时添加了 redness 属性。
public class EyeballMonster: Monster {
    public var redness = 0
    
    // 在初始化方法为新增加的属性赋值
    public init(health: Int, level: Int, redness: Int) {
        self.redness = redness
        super.init(health: health, level: level)
    }
    
    @available (*, unavailable, message: "Call copy() instead")
    public required convenience init(_ prototype: Monster) {
        let eyeballMonster = prototype as! EyeballMonster
        self.init(health: eyeballMonster.health,
                  level: eyeballMonster.level,
                  redness: eyeballMonster.redness)
    }
}
