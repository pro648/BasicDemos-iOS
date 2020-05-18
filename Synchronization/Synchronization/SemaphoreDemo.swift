//
//  SemaphoreDemo.swift
//  Synchronization
//
//  Created by pro648 on 2020/5/8.
//  Copyright © 2020 pro648. All rights reserved.
//

import UIKit

// 信号量

class SemaphoreDemo: BaseDemo {
    private var semaphore = DispatchSemaphore(value: 5)
    private var ticketSemaphore = DispatchSemaphore(value: 1)
    private var moneySemaphore = DispatchSemaphore(value: 1)
    
    override func otherTest() {
        for _ in 1...20 {
            Thread.init(target: self, selector: #selector(test), object: nil).start()
        }
    }
    
    @objc private func test() {
        _ = semaphore.wait(timeout: .distantFuture)
        
        sleep(1)
        print("Test - %@", Thread.current)
        
        semaphore.signal()
    }
    
    override func drawMoney() {
        _ = moneySemaphore.wait(timeout: .distantFuture)
        
        super.drawMoney()
        
        moneySemaphore.signal()
    }
    
    override func saveMoney() {
        _ = moneySemaphore.wait(timeout: .distantFuture)
        
        super.saveMoney()
        
        moneySemaphore.signal()
    }
    
    override func saleTicket() {
        _ = ticketSemaphore.wait(timeout: .distantFuture)
        
        super.saleTicket()
        
        ticketSemaphore.signal()
    }
}
