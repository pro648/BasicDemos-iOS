//
//  NormalMutexDemo.swift
//  Synchronization
//
//  Created by pro648 on 2020/5/7.
//  Copyright © 2020 pro648. All rights reserved.
//
// 详细介绍：[互斥锁](https://github.com/pro648/tips/wiki/%E7%BA%BF%E7%A8%8B%E5%90%8C%E6%AD%A5%E4%B9%8B%E4%BA%92%E6%96%A5%E9%94%81)

import UIKit

class NormalMutexDemo: BaseDemo {
    private var ticketMutex: pthread_mutex_t = pthread_mutex_t()
    private var moneyMutex: pthread_mutex_t = pthread_mutex_t()
    
    override init() {
        pthread_mutex_init(&ticketMutex, nil)
        pthread_mutex_init(&moneyMutex, nil)
        
        super.init()
    }
    
    override func saveMoney() {
        pthread_mutex_lock(&moneyMutex)
        
        super.saveMoney()
        
        pthread_mutex_unlock(&moneyMutex)
    }
    
    override func drawMoney() {
        pthread_mutex_lock(&moneyMutex)
        
        super.drawMoney()
        
        pthread_mutex_unlock(&moneyMutex)
    }
    
    override func saleTicket() {
        pthread_mutex_lock(&ticketMutex)
        
        super.saleTicket()
        
        pthread_mutex_unlock(&ticketMutex)
    }
    
    deinit {
        pthread_mutex_destroy(&moneyMutex)
        pthread_mutex_destroy(&ticketMutex)
    }
}
