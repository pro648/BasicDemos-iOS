//
//  NSConditionDemo.swift
//  Synchronization
//
//  Created by pro648 on 2020/5/8.
//  Copyright © 2020 pro648. All rights reserved.
//
//  [条件锁](https://github.com/pro648/tips/wiki/%E7%BA%BF%E7%A8%8B%E5%90%8C%E6%AD%A5%E4%B9%8B%E6%9D%A1%E4%BB%B6%E9%94%81)

import UIKit

class NSConditionDemo: BaseDemo {
    private var condition = NSCondition()
    private var data: [String] = []
    
    override func otherTest() {
        Thread.init(target: self, selector: #selector(removeEle), object: nil).start()
        Thread.init(target: self, selector: #selector(addEle), object: nil).start()
    }
    
    @objc private func addEle() {
        condition.lock()
        
        data.append("pro648")
        print("添加了元素")
        
        // 唤醒单个线程
        condition.signal()
        
        // 唤醒多个线程
//        condition.broadcast()
        
        condition.unlock()
    }
    
    @objc private func removeEle() {
        condition.lock()
        
        if data.count == 0 {
            condition.wait()
        }
        
        data.removeLast()
        print("移除了元素")
        
        condition.unlock()
    }
}
