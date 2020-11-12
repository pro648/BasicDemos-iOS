import Foundation

/// 使用两个栈实现队列
public struct QueueStack<T> : Queue {
    
    // 使用两个数组存储
    private var leftStack: [T] = []
    private var rightStack: [T] = []
    public init() { }
    
    public var isEmpty: Bool {
        // 队列是否为空，只有两个栈都为空时才为空。
        leftStack.isEmpty && rightStack.isEmpty
    }
    
    public var peek: T? {
        // 如果leftStack不为空，返回它的最后一个；如果为空，返回rightStack第一个。
        !leftStack.isEmpty ? leftStack.last : rightStack.first
    }
    
    public mutating func enqueue(_ element: T) -> Bool {
        // 入队时每次向 rightStack 添加
        rightStack.append(element)
        return true
    }
    
    public mutating func dequeue() -> T? {
        if leftStack.isEmpty {  // 如果 leftStack 为空，将rightStack反转后存入leftStack，并清空rightStack。
            leftStack = rightStack.reversed()
            rightStack.removeAll()
        } else {    // leftStack不为空，则移除最后一个元素。
            return leftStack.popLast()
        }
    }
}

extension QueueStack: CustomStringConvertible {
    public var description: String {
        String(describing: leftStack.reversed() + rightStack)
    }
}
