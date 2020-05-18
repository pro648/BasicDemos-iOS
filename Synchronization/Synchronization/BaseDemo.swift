//
//  BaseDemo.swift
//  Synchronization
//
//  Created by pro648 on 2020/5/7.
//  Copyright © 2020 pro648. All rights reserved.
//

import Foundation

class BaseDemo {
    private var ticketsCount = 25
    private var money = 100
    
    // MARK: - Money
    
    func moneyTest() {
        let queue = DispatchQueue.global(qos: .utility)
        
        queue.async {
            for _ in 1...10 {
                self.saveMoney()
            }
        }
        
        queue.async {
            for _ in 1...10 {
                self.drawMoney()
            }
        }
    }
    
    func drawMoney() {
        var oldMoney = money
        sleep(1)
        oldMoney -= 20
        money = oldMoney
        
        print("取20元，还剩余\(oldMoney)元 -- \(Thread.current)")
    }
    
    func saveMoney() {
        var oldMoney = money
        sleep(1)
        oldMoney += 50
        money = oldMoney
        
        print("存50元，还剩\(oldMoney)元 -- \(Thread.current)")
    }
    
    // MARK: - Sale Ticket
    
    func ticketTest() {
        let queue = DispatchQueue.global(qos: .utility)
        
        queue.async {
            for _ in 1...5 {
                self.saleTicket()
            }
        }
        
        queue.async {
            for _ in 1...5 {
                self.saleTicket()
            }
        }
        
        queue.async {
            for _ in 1...5 {
                self.saleTicket()
            }
        }
    }
    
    func saleTicket() {
        var oldTicketsCount = ticketsCount
        sleep(1)
        oldTicketsCount -= 1
        ticketsCount = oldTicketsCount
        
        print("还剩\(oldTicketsCount)张票 -- \(Thread.current)")
    }
    
    func otherTest() {
        
    }
}
