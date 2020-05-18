//
//  NSConditionLockDemo.swift
//  Synchronization
//
//  Created by pro648 on 2020/5/8.
//  Copyright © 2020 pro648. All rights reserved.
//
//  [条件锁](https://github.com/pro648/tips/wiki/%E7%BA%BF%E7%A8%8B%E5%90%8C%E6%AD%A5%E4%B9%8B%E6%9D%A1%E4%BB%B6%E9%94%81)

import UIKit

class NSConditionLockDemo: BaseDemo {
    private var conditionLock = NSConditionLock.init(condition: 1)
    private var data: [String] = []
    
    override func otherTest() {
        Thread.init(target: self, selector: #selector(one), object: nil).start()
        Thread.init(target: self, selector: #selector(two), object: nil).start()
        Thread.init(target: self, selector: #selector(three), object: nil).start()
    }
    
    @objc private func one() {
        conditionLock.lock(whenCondition: 1)
        
        data.append("pro648")
        print("one:\(data)")
        
        conditionLock.unlock(withCondition: 2)
    }
    
    @objc private func two() {
        conditionLock.lock(whenCondition: 2)
        
        data.removeLast()
        print("two:\(data)")
        
        conditionLock.unlock(withCondition: 3)
    }
    
    @objc private func three() {
        conditionLock.lock(whenCondition: 3)
        
        data.append("pro648")
        print("three:\(data)")
        
        conditionLock.unlock()
    }
}
