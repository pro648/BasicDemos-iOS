/*:
 详细介绍：[队列的四种实现方式：数组、双向链表、环形缓冲区、栈](https://github.com/pro648/tips/blob/master/sources/%E9%98%9F%E5%88%97%E7%9A%84%E5%9B%9B%E7%A7%8D%E5%AE%9E%E7%8E%B0%E6%96%B9%E5%BC%8F%EF%BC%9A%E6%95%B0%E7%BB%84%E3%80%81%E5%8F%8C%E5%90%91%E9%93%BE%E8%A1%A8%E3%80%81%E7%8E%AF%E5%BD%A2%E7%BC%93%E5%86%B2%E5%8C%BA%E3%80%81%E6%A0%88.md)
 */

import Foundation

public func testQueueArray() {
    var queue = QueueArray<String>()
    queue.enqueue("Ray")
    queue.enqueue("Brian")
    queue.enqueue("Eric")
    queue
    queue.dequeue()
    queue
    queue.peek
}

public func testQueueDoublyLinkedList() {
    let queue = QueueLinkedList<String>()
    queue.enqueue("Ray")
    queue.enqueue("Brian")
    queue.enqueue("Eric")
    queue
    queue.dequeue()
    queue
    queue.peek
}

public func testQueueRingBuffer() {
    var queue = QueueRingBuffer<String>(count: 3)
    queue.enqueue("Ray")
    queue.enqueue("Brian")
    queue.enqueue("Eric")
    queue
    queue.dequeue()
    queue
    queue.peek
}

public func testQueueStacks() {
    var queue = QueueStack<String>()
    queue.enqueue("Ray")
    queue.enqueue("Brian")
    queue.enqueue("Eric")
    queue
    queue.dequeue()
    queue
    queue.peek
}

testQueueArray()
testQueueDoublyLinkedList()
testQueueRingBuffer()
testQueueStacks()

//: [Next](@next)
