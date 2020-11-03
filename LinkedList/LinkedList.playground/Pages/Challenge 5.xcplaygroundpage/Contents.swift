//: [Previous](@previous)

import Foundation

// 删除链表中等于给定值的所有节点

extension LinkedList where Value: Equatable {
    mutating func removeAll(_ value: Value) {
        // 先处理 head 的值与指定值相同
        while let head = self.head, head.value == value {
            self.head = head.next
        }
        
        var prev = head
        var current = head?.next
        while let currentNode = current {
            guard currentNode.value != value else { // 如果节点值与要移除值相等，移动指针。
                prev?.next = currentNode.next
                current = prev?.next
                continue
            }
            
            prev = current
            current = current?.next
        }
        
        // tail 可能被移除
        tail = prev
    }
}

example(of: "deleting duplicate nodes") {
    var list = LinkedList<Int>()
    list.push(3)
    list.push(2)
    list.push(2)
    list.push(1)
    list.push(1)
    
    list.removeAll(2)
    print(list)
}

//: [Next](@next)
