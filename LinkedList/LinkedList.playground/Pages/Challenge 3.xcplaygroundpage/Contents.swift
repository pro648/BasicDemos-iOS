//: [Previous](@previous)

import Foundation

// 反转链表

extension LinkedList {
    mutating func reverse() {
        // 通过操控 node 的 next，避免创建额外的 node、LinkedList。
        tail = head
        var prev = head
        var current = head?.next
        prev?.next = nil
        
        while current != nil {  // 每次循环时，创建一个新的引用指向下一个节点。循环过程中，让每个节点指向上一个节点。
            let next = current?.next
            current?.next = prev
            prev = current
            current = next
        }
        
        // 循环结束时，设置 head 为 prev。
        head = prev
    }
}

example(of: "reversing a list") {
    var list = LinkedList<Int>()
    list.push(5)
    list.push(4)
    list.push(3)
    list.push(2)
    list.push(1)
    
    print("Original list: \(list)")
    list.reverse()
    print("Reversed list: \(list)")
}

//: [Next](@next)
