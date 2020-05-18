//
//  OSUnfairLockDemo.swift
//  Synchronization
//
//  Created by pro648 on 2020/5/7.
//  Copyright © 2020 pro648. All rights reserved.
//
//  [os_unfair_lock](https://github.com/pro648/tips/wiki/%E7%BA%BF%E7%A8%8B%E5%90%8C%E6%AD%A5%E4%B9%8Bos_unfair_lock)

import UIKit

class OSUnfairLockDemo: BaseDemo {
    private var moneyLock: os_unfair_lock = os_unfair_lock_s()
    private var ticketLock: os_unfair_lock = os_unfair_lock_s()
    
    override func drawMoney() {
        os_unfair_lock_lock(&moneyLock)
        
        super.drawMoney()
        
        os_unfair_lock_unlock(&moneyLock)
    }
    
    override func saveMoney() {
        os_unfair_lock_lock(&moneyLock)
        
        super.saveMoney()
        
        os_unfair_lock_unlock(&moneyLock)
    }
    
    override func saleTicket() {
        os_unfair_lock_lock(&ticketLock)
        
        super.saleTicket()
        
        os_unfair_lock_unlock(&ticketLock)
    }
}
