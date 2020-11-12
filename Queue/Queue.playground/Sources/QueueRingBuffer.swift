import Foundation

/// 使用环形缓冲区实现队列
public struct QueueRingBuffer<T>: Queue {
    
    /// 使用环形缓冲区存储
    private var ringBuffer: RingBuffer<T>
    
    /// 初始化队列
    /// - Parameter count: 指定队列的固定大小
    public init(count: Int) {
        ringBuffer = RingBuffer<T>(count: count)
    }
    
    public var isEmpty: Bool {
        ringBuffer.isEmpty
    }
    
    public var peek: T? {
        ringBuffer.first
    }
    
    /// 入队
    /// - Parameter element: 要入队的元素
    /// - Returns: 入队成功时，返回 true；反之，返回 false。当队列满时，入队会失败。
    public mutating func enqueue(_ element: T) -> Bool {
        ringBuffer.write(element)
    }
    
    /// 出队
    /// - Returns: 队列为空时，返回 nil；反之，返回出队的元素。
    public mutating func dequeue() -> T? {
        ringBuffer.read()
    }
}

extension QueueRingBuffer: CustomStringConvertible {
    public var description: String {
        String(describing: ringBuffer)
    }
}

// MARK: - Ring Buffer

public struct RingBuffer<T> {
    // 使用数组存储
    private var array: [T?]
    private var readIndex = 0
    private var writeIndex = 0
    
    public init(count: Int) {
        array = Array<T?>(repeating: nil, count: count)
    }
    
    public var first: T? {
        array[readIndex]
    }
    
    /// 入队。
    /// - Parameter element: 要入队的原
    /// - Returns: 入队成功时，返回 true；反之，返回 false。当队列满时，入队会失败。
    public mutating func write(_ element: T) -> Bool {
        if !isFull {
            array[writeIndex % array.count] = element
            writeIndex += 1
            return true
        } else {
            return false
        }
    }
    
    /// 出队
    /// - Returns: 队列为空时，返回 nil；反之，返回出队的元素。
    public mutating func read() -> T? {
        if !isEmpty {
            let element = array[readIndex % array.count]
            readIndex += 1
            return element
        } else {
            return nil
        }
    }
    
    private var availableSpaceForReading: Int {
        writeIndex - readIndex
    }
    
    public var isEmpty: Bool {
        availableSpaceForReading == 0
    }
    
    private var availableSpaceForWriting: Int {
        array.count - availableSpaceForReading
    }
    
    public var isFull: Bool {
        availableSpaceForWriting == 0
    }
}

extension RingBuffer: CustomStringConvertible {
    public var description: String {
        let values = (0..<availableSpaceForReading).map {
            String(describing: array[($0 + readIndex) % array.count]!)
        }
        return "[" + values.joined(separator: ", ") + "]"
    }
}
