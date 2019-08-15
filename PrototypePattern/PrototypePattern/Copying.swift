//
//  Copying.swift
//  PrototypePattern
//
//  Created by pro648 on 2019/8/13.
//  Copyright © 2019 pro648. All rights reserved.
//

import Foundation

public protocol Copying: class {
    // 声明 required initializer
    init(_ prototype: Self)
}

extension Copying {
    // 通常不直接调用初始化器，而是调用 copy() 方法
    public func copy() -> Self {
        return type(of: self).init(self)
    }
}
