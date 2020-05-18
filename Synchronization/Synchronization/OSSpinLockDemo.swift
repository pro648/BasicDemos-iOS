//
//  OSSpinLockDemo.swift
//  Synchronization
//
//  Created by pro648 on 2020/5/7.
//  Copyright © 2020 pro648. All rights reserved.
//
// 详细介绍：[自旋锁](https://github.com/pro648/tips/wiki/%E7%BA%BF%E7%A8%8B%E5%90%8C%E6%AD%A5%E4%B9%8B%E8%87%AA%E6%97%8B%E9%94%81)

import UIKit

class OSSpinLockDemo: BaseDemo {
    private var moneyLock: OSSpinLock = OS_SPINLOCK_INIT
    private var ticketLock: OSSpinLock = OS_SPINLOCK_INIT
    
    override func drawMoney() {
        OSSpinLockLock(&moneyLock)
        
        super.drawMoney()
        
        OSSpinLockUnlock(&moneyLock)
    }
    
    override func saveMoney() {
        OSSpinLockLock(&moneyLock)
        
        super.saveMoney()
        
        OSSpinLockUnlock(&moneyLock)
    }
    
    override func saleTicket() {
        OSSpinLockLock(&ticketLock)
        
        super.saleTicket()
        
        OSSpinLockUnlock(&ticketLock)
    }
}
