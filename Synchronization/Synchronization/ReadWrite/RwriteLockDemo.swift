//
//  RwriteLockDemo.swift
//  Synchronization
//
//  Created by pro648 on 2020/5/14.
//  Copyright © 2020 pro648. All rights reserved.
//
//  [读写锁](https://github.com/pro648/tips/wiki/%E7%BA%BF%E7%A8%8B%E5%90%8C%E6%AD%A5%E4%B9%8B%E8%AF%BB%E5%86%99%E9%94%81)

import UIKit

class RwriteLockDemo: BaseDemo {
    private var rwLock = pthread_rwlock_t()
    
    override init() {
        pthread_rwlock_init(&rwLock, nil)
        
        super.init()
        
//        let queue = DispatchQueue.global(qos: .utility)
        for _ in 1...10 {
            
            Thread.init(target: self, selector: #selector(read), object: nil).start()
            Thread.init(target: self, selector: #selector(read), object: nil).start()
            
            Thread.init(target: self, selector: #selector(write), object: nil).start()
            Thread.init(target: self, selector: #selector(write), object: nil).start()
        }
    }
    
    @objc private func read() {
        // 添加读锁
        pthread_rwlock_rdlock(&rwLock)
        
        sleep(1)
        print("read")
        
        pthread_rwlock_unlock(&rwLock)
    }
    
    @objc private func write() {
        // 添加写锁
        pthread_rwlock_wrlock(&rwLock)
        
        sleep(1)
        print("write")
        
        pthread_rwlock_unlock(&rwLock)
    }
    
    deinit {
        pthread_rwlock_destroy(&rwLock)
    }
}
