//: [Previous](@previous)

/*:
 ## 双端队列
 
 双端队列是一种具有队列和栈性质的抽象数据类型，可以从两端插入、移除双端队列的元素。
 */

import Foundation

enum Direction {
    case front
    case back
}

protocol Deque {
    associatedtype Element
    var isEmpty:Bool { get }
    func peek(from direction: Direction) -> Element?
    
    mutating func enqueue(_ element: Element, to direction: Direction) -> Bool
    mutating func dequeue(from direction: Direction) -> Element?
}

class DequeDoubleLinkedList<Element>: Deque {
    // 使用双向链表存储
    private var list = DoublyLinkedList<Element>()
    public init() { }
    
    var isEmpty: Bool {
        list.isEmpty
    }
    
    func peek(from direction: Direction) -> Element? {
        // 根据direction决定查看first还是last。
        switch direction {
        case .front:
            return list.first?.value
        
        case .back:
            return list.last?.value
        }
    }
    
    func enqueue(_ element: Element, to direction: Direction) -> Bool {
        // 根据direction决定添加方式。
        switch direction {
        case .front:
            // 会将 element 设置为新的头节点
            list.prepend(element)
            
        case .back:
            // 会将 element 设置为新的尾节点
            list.append(element)
        }
        
        return true
    }
    
    func dequeue(from direction: Direction) -> Element? {
        let element: Element?
        
        // 双向链表有指向前、后结点的指针，只需移除指针即可。
        switch direction {
        case .front:
            guard let first = list.first else { return nil }
            element = list.remove(first)
            
        case .back:
            guard let last = list.last else { return nil }
            element = list.remove(last)
        }
        return element
    }
}

extension DequeDoubleLinkedList: CustomStringConvertible {
    public var description: String {
        String(describing: list)
    }
}

let deque = DequeDoubleLinkedList<Int>()
deque.enqueue(1, to: .back)
deque.enqueue(2, to: .back)
deque.enqueue(3, to: .back)
deque.enqueue(4, to: .back)

print(deque)

deque.enqueue(5, to: .front)

print(deque)

deque.dequeue(from: .back)
deque.dequeue(from: .back)
deque.dequeue(from: .back)
deque.dequeue(from: .front)
deque.dequeue(from: .front)
deque.dequeue(from: .front)

print(deque)
