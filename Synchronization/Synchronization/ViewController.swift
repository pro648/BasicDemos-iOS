//
//  ViewController.swift
//  Synchronization
//
//  Created by pro648 on 2020/5/7.
//  Copyright © 2020 pro648. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        let demo = OSSpinLockDemo()
//        let demo = OSUnfairLockDemo()
//        let demo = NormalMutexDemo()
//        let demo = RecursiveMutexDemo()
//        let demo = NSRecursiveLockDemo()
//        let demo = ConditionMutexDemo()
//        let demo = NSLockDemo()
//        let demo = NSConditionDemo()
//        let demo = NSConditionLockDemo()
//        let demo = SerialQueueDemo()
//        let demo = SemaphoreDemo()
//        let demo = SynchronizedDemo()
        let demo = RwriteLockDemo()
//        let demo = BarrierQueueDemo()
        
//        demo.moneyTest()
//        demo.ticketTest()
//        demo.otherTest()
        
    }
}

