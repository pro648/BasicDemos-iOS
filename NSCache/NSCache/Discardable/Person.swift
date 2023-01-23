//
//  Person.swift
//  NSCache
//
//  Created by ad on 2023/1/23.
//

import UIKit

class Person {
    let firstName: String
    let lastName: String
    var avatar: UIImage? = nil
    
    // Our counter variable
    var accessCounter = true
    
    init(firstName: String, lastName: String, avatar: UIImage?) {
        self.firstName = firstName
        self.lastName = lastName
        self.avatar = avatar
    }
}

extension Person: NSDiscardableContent {
    // 开始读取内容时调用
    func beginContentAccess() -> Bool {
        if avatar != nil {
            accessCounter = true
        } else {
            accessCounter = false
        }
        return accessCounter
    }
    
    // 不再需要内容时调用
    func endContentAccess() {
        accessCounter = false
    }
    
    // 如果内容不再使用，释放掉。
    func discardContentIfPossible() {
        avatar = nil
    }
    
    // 如果已经释放了，返回true。
    func isContentDiscarded() -> Bool {
        return avatar == nil
    }
}
