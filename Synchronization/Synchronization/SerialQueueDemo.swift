//
//  SerialQueueDemo.swift
//  Synchronization
//
//  Created by pro648 on 2020/5/8.
//  Copyright © 2020 pro648. All rights reserved.
//

import UIKit

// 串行队列

class SerialQueueDemo: BaseDemo {
    private var ticketQueue = DispatchQueue(label: "ticketQueue")
    private var moneyQueue = DispatchQueue(label: "moneyQueue")
    
    override func drawMoney() {
        moneyQueue.sync {
            super.drawMoney()
        }
    }
    
    override func saveMoney() {
        moneyQueue.sync {
            super.saveMoney()
        }
    }
    
    override func saleTicket() {
        ticketQueue.sync {
            super.saleTicket()
        }
    }
}
