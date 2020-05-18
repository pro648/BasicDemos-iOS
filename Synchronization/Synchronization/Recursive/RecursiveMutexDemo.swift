//
//  RecursiveMutexDemo.swift
//  Synchronization
//
//  Created by pro648 on 2020/5/7.
//  Copyright © 2020 pro648. All rights reserved.
//
//  [递归锁](https://github.com/pro648/tips/wiki/%E7%BA%BF%E7%A8%8B%E5%90%8C%E6%AD%A5%E4%B9%8B%E9%80%92%E5%BD%92%E9%94%81)

import UIKit

// 递归锁：允许同一线程对同一把锁重复加锁。

class RecursiveMutexDemo: BaseDemo {
    private var recursiveMutex = pthread_mutex_t()
    
    override init() {
        // 初始化属性
        var attr = pthread_mutexattr_t()
        pthread_mutexattr_init(&attr)
        pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE)
        
        // 初始化锁
        pthread_mutex_init(&recursiveMutex, &attr)
        
        // 销毁属性
        pthread_mutexattr_destroy(&attr)
        
        super.init()
    }
    
    override func otherTest() {
        pthread_mutex_lock(&recursiveMutex)
        
        struct Holder {
            static var count = 0
        }
        Holder.count += 1
        print("count = \(Holder.count)")
        if Holder.count < 10 {
            self.otherTest()
        }
        
        pthread_mutex_unlock(&recursiveMutex)
    }
    
    deinit {
        pthread_mutex_destroy(&recursiveMutex)
    }
}
