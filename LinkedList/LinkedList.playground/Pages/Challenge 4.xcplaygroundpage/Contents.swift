//: [Previous](@previous)

import Foundation

// 合并两个有序链表

func mergeSorted<T: Comparable>(_ left: LinkedList<T>, _ right: LinkedList<T>) -> LinkedList<T> {
    // 如果一个链表为空，则直接返回另一个链表
    guard !left.isEmpty else {
        return right
    }
    guard !right.isEmpty else {
        return left
    }
    
    var newHead: Node<T>?
    var tail: Node<T>?
    var currentLeft = left.head
    var currentRight = right.head
    
    if let leftNode = currentLeft, let rightNode = currentRight {
        if leftNode.value < rightNode.value {
            newHead = leftNode
            currentLeft = leftNode.next
        } else {
            newHead = rightNode
            currentRight = rightNode.next
        }
        
        tail = newHead
    }
    
    while let leftNode = currentLeft, let rightNode = currentRight {    // 循环会持续到任意链表为空
        // 比较值
        if leftNode.value < rightNode.value {
            tail?.next = leftNode
            currentLeft = leftNode.next
        } else {
            tail?.next = rightNode
            currentRight = rightNode.next
        }
        
        tail = tail?.next
    }
    
    // 把剩余链表拼接上去
    if let leftNodes = currentLeft {
        tail?.next = leftNodes
    }
    if let rightNodes = currentRight {
        tail?.next = rightNodes
    }
    
    // 创建新的链表，设置head、tail。
    var list = LinkedList<T>()
    list.head = newHead
    list.tail = {
        while let next = tail?.next {
            tail = next
        }
        return tail
    }()
    return list
}

example(of: "merging two lists") {
    var list = LinkedList<Int>()
    list.push(5)
    list.push(4)
    list.push(1)
    
    var anotherList = LinkedList<Int>()
    anotherList.push(6)
    anotherList.push(3)
    anotherList.push(2)
    anotherList.push(1)
    
    print("First list: \(list)")
    print("Second list: \(anotherList)")
    
    let mergedList = mergeSorted(list, anotherList)
    print("Merged list: \(mergedList)")
}

//: [Next](@next)
