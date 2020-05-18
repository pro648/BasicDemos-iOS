//
//  NSLockDemo.swift
//  Synchronization
//
//  Created by pro648 on 2020/5/8.
//  Copyright © 2020 pro648. All rights reserved.
//
// 详细介绍：[互斥锁](https://github.com/pro648/tips/wiki/%E7%BA%BF%E7%A8%8B%E5%90%8C%E6%AD%A5%E4%B9%8B%E4%BA%92%E6%96%A5%E9%94%81)

import UIKit

class NSLockDemo: BaseDemo {
    private var ticketLock = NSLock()
    private var moneyLock = NSLock()
    
    override func saveMoney() {
        moneyLock.lock()
        
        super.saveMoney()
        
        moneyLock.unlock()
    }
    
    override func drawMoney() {
        moneyLock.lock()
        
        super.drawMoney()
        
        moneyLock.unlock()
    }
    
    override func saleTicket() {
        ticketLock.lock()
        
        super.saleTicket()
        
        ticketLock.unlock()
    }
}
