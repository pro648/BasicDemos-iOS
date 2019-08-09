//
//  ViewController.swift
//  IteratorPattern
//
//  Created by pro648 on 2019/8/2.
//  Copyright © 2019 pro648. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // 初始化 Queue 对象，并添加四个对象。
        var queue = Queue<Ticket>()
        queue.enqueue(Ticket(description: "Wireframe Tinder for dogs app", priority: .low))
        queue.enqueue(Ticket(description: "Set up 4k monitor for Josh", priority: .medium))
        queue.enqueue(Ticket(description: "There is smoke coming out of my laptop", priority: .high))
        queue.enqueue(Ticket(description: "Put googly eyes on the Roomba", priority: .low))
        
        // 可以看到 dequeue 的是第一个添加的对象
        let element = queue.dequeue()
        print((element?.description ?? "No Description") + "\n")
        
        // 枚举 queue 并输出
        print("List of Tickets in queue:")
        for ticket in queue {
            print(ticket?.description ?? "No Description")
        }
        
        // 进行排序
        let sortedTickets = queue.sorted {
            $0!.sortIndex > ($1?.sortIndex)!
        }
        
        // 循环 sortedTickets 数组，将元素添加到 sortedQueue
        var sortedQueue = Queue<Ticket>()
        for ticket in sortedTickets {
            sortedQueue.enqueue(ticket!)
        }
        
        // 输出 sotedQueue 内对象，可以看到 first in, firt out。
        print("\n")
        print("Tickets sorted by priority:")
        for ticket in sortedQueue {
            print(ticket?.description ?? "No Description")
        }
    }


}

