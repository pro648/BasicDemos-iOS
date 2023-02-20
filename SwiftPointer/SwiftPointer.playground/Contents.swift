// 详细介绍：https://github.com/pro648/tips/blob/master/sources/Swift%E6%8C%87%E9%92%88%E7%9A%84%E4%BD%BF%E7%94%A8.md

import Foundation

// MemoryLayout
MemoryLayout<Int>.size          // returns 8
MemoryLayout<Int>.alignment     // returns 8
MemoryLayout<Int>.stride        // returns 8

MemoryLayout<Int16>.size        // returns 2
MemoryLayout<Int16>.alignment   // returns 2
MemoryLayout<Int16>.stride      // returns 2

MemoryLayout<Bool>.size         // returns 1
MemoryLayout<Bool>.alignment    // returns 1
MemoryLayout<Bool>.stride       // returns 1

MemoryLayout<Float>.size        // returns 4
MemoryLayout<Float>.alignment   // returns 4
MemoryLayout<Float>.stride      // returns 4

MemoryLayout<Double>.size       // returns 8
MemoryLayout<Double>.alignment  // returns 8
MemoryLayout<Double>.stride     // returns 8

// Struct
struct EmptyStruct {}

MemoryLayout<EmptyStruct>.size      // returns 0
MemoryLayout<EmptyStruct>.alignment // returns 1
MemoryLayout<EmptyStruct>.stride    // returns 1

struct SampleStruct {
    let number: UInt32
    let flag: Bool
}

MemoryLayout<SampleStruct>.size       // returns 5
MemoryLayout<SampleStruct>.alignment  // returns 4
MemoryLayout<SampleStruct>.stride     // returns 8

// 类与结构体的区别

class EmptyClass { }

MemoryLayout<EmptyClass>.size      // returns 8
MemoryLayout<EmptyClass>.stride    // returns 8
MemoryLayout<EmptyClass>.alignment // returns 8

class SampleClass {
    let number: Int64 = 0
    let flag = false
}

MemoryLayout<SampleClass>.size      // returns 8
MemoryLayout<SampleClass>.stride    // returns 8
MemoryLayout<SampleClass>.alignment // returns 8

// Raw Pointer
// 常用数据
let count = 2
let stride = MemoryLayout<Int>.stride
let alignment = MemoryLayout<Int>.alignment
let byteCount = stride * count

// 增加作用域，方便相同变量名称重复使用。
do {
    print("Raw pointers")
    
    // 初始化指定byte内存空间
    let pointer = UnsafeMutableRawPointer.allocate(byteCount: byteCount, alignment: alignment)
    // 确保释放分配的内存空间
    defer {
        pointer.deallocate()
    }
    
    // store、advance、load byte
    pointer.storeBytes(of: 42, as: Int.self)
    pointer.advanced(by: stride).storeBytes(of: 6, as: Int.self)
    pointer.load(as: Int.self)
    pointer.advanced(by: stride).load(as: Int.self)
    
    // 使用UnsafeRawBufferPointer像byte collection一样访问ponter变量的内存
    let bufferPointer = UnsafeRawBufferPointer(start: pointer, count: byteCount)
    for (index, byte) in bufferPointer.enumerated() {
        print("byte \(index): \(byte)")
    }
}

do {
    print("Typed pointers")
    
    let pointer = UnsafeMutablePointer<Int>.allocate(capacity: count)
    pointer.initialize(repeating: 0, count: count)
    defer {
        pointer.deinitialize(count: count)
        pointer.deallocate()
    }
    
    pointer.pointee = 42
    pointer.advanced(by: 1).pointee = 6
    pointer.pointee
    pointer.advanced(by: 1).pointee
    
    let bufferPointer = UnsafeBufferPointer(start: pointer, count: count)
    for (index, value) in bufferPointer.enumerated() {
        print("value \(index): \(value)")
    }
}

do {
    print("Converting raw pointers to typed pointers")
    
    let rawPointer = UnsafeMutableRawPointer.allocate(byteCount: byteCount, alignment: alignment)
    defer {
        rawPointer.deallocate()
    }
    
    let typedPointer = rawPointer.bindMemory(to: Int.self, capacity: count)
    typedPointer.initialize(repeating: 0, count: count)
    defer {
        typedPointer.deinitialize(count: count)
    }
    
    typedPointer.pointee = 42
    typedPointer.advanced(by: 1).pointee = 6
    typedPointer.pointee
    typedPointer.advanced(by: 1).pointee
    
    let bufferPointer = UnsafeBufferPointer(start: typedPointer, count: count)
    for (index, value) in bufferPointer.enumerated() {
        print("value \(index): \(value)")
    }
}

do {
    print("Getting the bytes of an instance")
    
    var sampleStruct = SampleStruct(number: 64, flag: true)
    
    withUnsafeBytes(of: &sampleStruct) { bytes in
        for byte in bytes {
            print(byte)
        }
    }
}

// 计算校验和
do {
    print("Checksum the bytes of a struct")
    
    var sampleStruct = SampleStruct(number: 64, flag: true)
    
    let checksum = withUnsafeBytes(of: &sampleStruct) { (bytes) -> UInt32 in
        return ~bytes.reduce(UInt32(0)) { $0 + numericCast($1) }
    }
    
    print("checksum", checksum) // prints checksum 4294967230
}

// withUnsafeBytes方法闭包不能返回指针
do {
    print("1. Don't return the pointer from withUnsafeBytes!")
    
    var sampleStruct = SampleStruct(number: 64, flag: true)
    
    let bytes = withUnsafeBytes(of: &sampleStruct) { bytes in
        return bytes // strange bugs here we come ☠️☠️☠️
    }
    
    print("Horse is out of the barn!", bytes) // undefined!!!
}

// 指针只能绑定一种类型
do {
    print("2. Only bind to one type at a time!")
    
    let count = 3
    let stride = MemoryLayout<Int16>.stride
    let alignment = MemoryLayout<Int16>.alignment
    let byteCount = count * stride
    
    let pointer = UnsafeMutableRawPointer.allocate(byteCount: byteCount, alignment: alignment)
    
    let typedPointer1 = pointer.bindMemory(to: UInt16.self, capacity: count)
    
    // Breakin' the Law... Breakin' the Law (Undefined behavior)
    let typedPointer2 = pointer.bindMemory(to: Bool.self, capacity: count * 2)
    
    // If you must, do it this way:
    typedPointer1.withMemoryRebound(to: Bool.self, capacity: count * 2) {
        (boolPointer: UnsafeMutablePointer<Bool>) in
        print(boolPointer.pointee) // See Rule #1, don't return the pointer
    }
}

// 指针越界
do {
    print("3. Don't walk off the end... whoops!")
    
    let count = 3
    let stride = MemoryLayout<Int16>.stride
    let alignment = MemoryLayout<Int16>.alignment
    let byteCount =  count * stride
    
    let pointer = UnsafeMutableRawPointer.allocate(
        byteCount: byteCount,
        alignment: alignment)
    let bufferPointer = UnsafeRawBufferPointer(start: pointer, count: byteCount + 1)
    // OMG +1????
    
    for byte in bufferPointer {
        print(byte) // pawing through memory like an animal
    }
}
