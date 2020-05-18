//
//  BarrierQueueDemo.swift
//  Synchronization
//
//  Created by pro648 on 2020/5/14.
//  Copyright © 2020 pro648. All rights reserved.
//
//  [读写锁](https://github.com/pro648/tips/wiki/%E7%BA%BF%E7%A8%8B%E5%90%8C%E6%AD%A5%E4%B9%8B%E8%AF%BB%E5%86%99%E9%94%81)

import UIKit

class BarrierQueueDemo: BaseDemo {
    private var barrierQueue = DispatchQueue.init(label: "BarrierQueue", qos: .utility)
    
    override init() {
        super.init()
        
        for _ in 1...10 {
            DispatchQueue.global(qos: .utility).async {
                self.read()
            }
            DispatchQueue.global(qos: .utility).async {
                self.read()
            }
            
            DispatchQueue.global(qos: .utility).async {
                self.write()
            }
            DispatchQueue.global(qos: .utility).async {
                self.write()
            }
        }
    }
    
    private func read() {
        barrierQueue.async {
            sleep(1)
            print("read")
        }
    }
    
    private func write() {
        barrierQueue.async(flags: .barrier) {
            sleep(1)
            print("write")
        }
    }
}
