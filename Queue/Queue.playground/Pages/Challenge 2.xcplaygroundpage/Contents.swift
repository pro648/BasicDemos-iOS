
//: [Previous](@previous)

/*:
 ## 反转队列
 
 实现一个算法，对队列进行反转。
 */

import UIKit

extension QueueArray {
    func reversed() -> QueueArray {
        // 创建 queue 副本
        var queue = self
        // 创建 stack
        var stack = Stack<T>()
        
        // dequeue queue的所有元素，并添加到 stack。
        while let element = queue.dequeue() {
            stack.push(element)
        }
        
        // 将 stack pop 后添加到 queue。
        while let element = stack.pop() {
            queue.enqueue(element)
        }
        
        return queue
    }
}

var queue = QueueArray<String>()
queue.enqueue("1")
queue.enqueue("8")
queue.enqueue("11")
queue.enqueue("648")

print("before: \(queue)")
print("after: \(queue.reversed())")

//: [Next Challenge](@next)
