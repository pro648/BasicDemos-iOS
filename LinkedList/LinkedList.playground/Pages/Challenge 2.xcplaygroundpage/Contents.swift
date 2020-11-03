//: [Previous](@previous)

// 查找链表的中间节点

import Foundation

func getMiddle<T>(_ list: LinkedList<T>) -> Node<T>? {
    var slow = list.head
    var fast = list.head
    
    // fast 遍历速度是 slow 的二倍，fast 到达终点时，slow 刚好处于中间。
    while let nextFast = fast?.next {
        fast = nextFast.next
        slow = slow?.next
    }
    
    return slow
}

example(of: "getting the middle node") {
    var list = LinkedList<Int>()
    list.push(3)
    list.push(2)
    list.push(1)
    
    print(list)
    
    if let middleNode = getMiddle(list) {
        print(middleNode)
    }
}

//: [Next](@next)
