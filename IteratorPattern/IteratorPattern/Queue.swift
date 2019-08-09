//
//  Queue.swift
//  IteratorPattern
//
//  Created by pro648 on 2019/8/2.
//  Copyright © 2019 pro648. All rights reserved.
//

import Foundation

public struct Queue<T> {
    // 数组元素可以为任意类型。
    private var array: [T?] = []
    
    // Queue 的头部是数组第一个元素
    private var head = 0
    
    // 确认数组是否为空
    public var isEmpty: Bool {
        return count == 0
    }
    
    // Queue 内对象数量
    public var count: Int {
        return array.count - head
    }
    
    // 添加对象到 Queue
    public mutating func enqueue(_ element: T) {
        array.append(element)
    }
    
    // 从 Queue 队列移除对象
    public mutating func dequeue() -> T? {
        guard head < array.count,
            let element = array[head] else {
                return nil
        }
        
        array[head] = nil
        head += 1
        
        let percentage = Double(head)/Double(array.count)
        
        if array.count > 50,
            percentage > 0.25 {
            array.removeFirst(head)
            head = 0
        }
        
        return element
    }
}

extension Queue: Sequence {
    public func makeIterator() -> IndexingIterator<ArraySlice<T?>> {
        // 只枚举非空对象
        let nonEmptyValues = array[head ..< array.count]
        return nonEmptyValues.makeIterator()
    }
}
