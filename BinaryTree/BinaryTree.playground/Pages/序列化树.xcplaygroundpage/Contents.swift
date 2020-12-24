//: [Previous](@previous)

/*:
 ### 序列化树
 
 序列化是将一个数据结构或者对象转换为连续比特位的操作，进而可以将转换后的数据存储在文件、内存中，同时可通过网络传输到其他计算机。通过相反的方式（即反序列化）可以得到原数据。

 常用序列化的地方就是 JSON 转换。你的任务就是将二叉树序列化为数组，并将数组反序列化为之前的二叉树。
 */

import Foundation

var tree: BinaryNode<Int> = {
    let zero = BinaryNode(value: 0)
    let one = BinaryNode(value: 1)
    let five = BinaryNode(value: 5)
    let seven = BinaryNode(value: 7)
    let eight = BinaryNode(value: 8)
    let nine = BinaryNode(value: 9)
    
    seven.leftChild = one
    one.leftChild = zero
    one.rightChild = five
    seven.rightChild = nine
    nine.leftChild = eight
    
    return seven
}()

/// 序列化二叉树
func serialize<T>(_ node: BinaryNode<T>) -> [T?] {
    var array: [T?] = []
    node.traversePreOrder(visit: {
        array.append($0)
    })
    return array
}

/// 反序列化
func deserialize<T>(_ array: inout [T?]) -> BinaryNode<T>? {
//    // value 为空时表示节点没有子树，递归结束。
//    guard let value = array.removeFirst() else { return nil }
    
    guard !array.isEmpty, let value = array.removeLast() else {
        return nil
    }
    
    // 使用 value 创建节点，并设置左子树、右子树。
    let node = BinaryNode(value: value)
    node.leftChild = deserialize(&array)
    node.rightChild = deserialize(&array)
    return node
}

/// 调用该方法进行反序列化
func deserialize<T>(_ array: [T?]) -> BinaryNode<T>? {
    // 先反转数组
    var reversed = Array(array.reversed())
    return deserialize(&reversed)
}

print(tree)
var array = serialize(tree)
//if let node = deserialize(&array) {
// 使用优化后的反序列化方法
if let node = deserialize(array) {
    print(node)
}

//: [Next](@next)
