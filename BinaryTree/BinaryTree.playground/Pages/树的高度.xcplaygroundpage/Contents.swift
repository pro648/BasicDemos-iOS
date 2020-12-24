//: [Previous](@previous)

/*:
 ### 树的高度
 
 计算二叉树的高度。二叉树的高度是根节点到最远叶子节点的距离，只有一个节点时高度为零，因为它既是根节点，又是叶子节点。
 */

import Foundation

func height<T>(of node: BinaryNode<T>?) -> Int {
    guard let node = node else { return -1 }
    
    return 1 + max(height(of: node.leftChild), height(of: node.rightChild))
}

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

print(tree)

print("Height of tree: \(height(of: tree))")

//: [Next](@next)
