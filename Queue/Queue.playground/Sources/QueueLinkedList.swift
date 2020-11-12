import Foundation

/// 使用双向链表实现队列
public class QueueLinkedList<T>: Queue {
    // 内部存储使用双向链表
    private var list = DoublyLinkedList<T>()
    public init() { }
    
    /// 入队。
    /// - Parameter element: 要入队的元素
    /// - Returns: 入队成功，返回 true；反之，返回 false。使用基于链表的队列，不会入队失败。
    public func enqueue(_ element: T) -> Bool {
        list.append(element)
        return true
    }
    
    /// 出队，并返回出队的元素。
    /// - Returns: 队列为空时，返回空；反之，返回移除的元素。
    public func dequeue() -> T? {
        guard !list.isEmpty, let element = list.first else {
            return nil
        }
        
        return list.remove(element)
    }
    
    public var peek: T? {
        list.first?.value
    }
    
    public var isEmpty: Bool {
        list.isEmpty
    }
}

extension QueueLinkedList: CustomStringConvertible {
    public var description: String {
        String(describing: list)
    }
}
