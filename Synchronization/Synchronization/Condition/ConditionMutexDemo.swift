//
//  ConditionMutexDemo.swift
//  Synchronization
//
//  Created by pro648 on 2020/5/7.
//  Copyright © 2020 pro648. All rights reserved.
//
//  [条件锁](https://github.com/pro648/tips/wiki/%E7%BA%BF%E7%A8%8B%E5%90%8C%E6%AD%A5%E4%B9%8B%E6%9D%A1%E4%BB%B6%E9%94%81)

import UIKit

// 条件锁：获取锁后发现当前业务无法处理，需满足指定条件后才可以继续处理时使用的一种锁。

class ConditionMutexDemo: BaseDemo {
    private var mutex = pthread_mutex_t()
    private var cond = pthread_cond_t()
    private var data: [String] = []
    
    override init() {
        // 初始化属性
        var attr = pthread_mutexattr_t()
        pthread_mutexattr_init(&attr)
        pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE)
        
        // 初始化锁
        pthread_mutex_init(&mutex, &attr)
        
        // 销毁属性
        pthread_mutexattr_destroy(&attr)
        
        // 初始化条件
        pthread_cond_init(&cond, nil)
        
        super.init()
    }
    
    override func otherTest() {
        Thread.init(target: self, selector: #selector(addEle), object: nil).start()
        Thread.init(target: self, selector: #selector(removeEle), object: nil).start()
    }
    
    @objc private func addEle() {
        pthread_mutex_lock(&mutex)
        
        data.append("test")
        print("添加了元素")
        
        // 唤醒单个线程
        pthread_cond_signal(&cond)
        
        // 唤醒多个线程
//        pthread_cond_broadcast(&cond)
        
        pthread_mutex_unlock(&mutex)
    }
    
    @objc private func removeEle() {
        pthread_mutex_lock(&mutex)
        
        if data.count == 0 {
            pthread_cond_wait(&cond, &mutex)
        }
        
        data.removeLast()
        print("移除了元素")
        
        pthread_mutex_unlock(&mutex)
    }
    
    deinit {
        pthread_mutex_destroy(&mutex)
        
        pthread_cond_destroy(&cond)
    }
}
