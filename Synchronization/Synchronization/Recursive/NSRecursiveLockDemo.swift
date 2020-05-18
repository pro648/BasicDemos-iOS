//
//  NSRecursiveLockDemo.swift
//  Synchronization
//
//  Created by pro648 on 2020/5/12.
//  Copyright © 2020 pro648. All rights reserved.
//
//  [递归锁](https://github.com/pro648/tips/wiki/%E7%BA%BF%E7%A8%8B%E5%90%8C%E6%AD%A5%E4%B9%8B%E9%80%92%E5%BD%92%E9%94%81)

import UIKit

// 递归锁：允许同一线程对同一把锁重复加锁。

class NSRecursiveLockDemo: BaseDemo {
    
    private var recursiveLock = NSRecursiveLock()
    var num = 0
    
    override func otherTest() {
        recursiveLock.lock()

        struct Holder {
            static var count = 0
        }
        Holder.count += 1
        print("count = \(Holder.count)")
        if Holder.count < 10 {
            self.otherTest()
        }

        recursiveLock.unlock()
    }
}
