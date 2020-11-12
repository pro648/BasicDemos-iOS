import Foundation

/// 使用数组实现队列
public struct QueueArray<T>: Queue {
    
    // 存储使用数组
    private var array: [T] = []
    public init() { }
    
    // MARK: - Queue Protocol
    
    public var isEmpty: Bool {
        array.isEmpty
    }
    
    public var peek: T? {
        array.first
    }
    
    /// 入队元素
    /// - Parameter element: 要入队的元素
    /// - Returns: 入队成功，返回true；入队失败，返回false。
    public mutating func enqueue(_ element: T) -> Bool {
        array.append(element)
        return true
    }
    
    /// 出队元素
    /// - Returns: 出队的元素。当队列为空时，返回nil。
    public mutating func dequeue() -> T? {
        isEmpty ? nil : array.removeFirst()
    }
}

extension QueueArray: CustomStringConvertible {
    public var description: String {
        String(describing: array)
    }
}
