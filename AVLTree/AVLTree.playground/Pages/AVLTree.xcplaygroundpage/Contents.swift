/*:
 ### AVL树
 - 查找、删除、插入后自动恢复平衡
 - 复杂度保持O(log n)
 
 [查看详细介绍](https://github.com/pro648/tips/blob/master/sources/AVL%E6%A0%91.md)
 */

import UIKit

example(of: "repeated insertions in sequence") {
    var tree = AVLTree<Int>()
    for i in 0..<15 {
        tree.insert(i)
    }
    print(tree)
}

example(of: "removing a value") {
    var tree = AVLTree<Int>()
    tree.insert(15)
    tree.insert(10)
    tree.insert(16)
    tree.insert(18)
    print(tree)
    tree.remove(10)
    print(tree)
}

//: [Next](@next)
