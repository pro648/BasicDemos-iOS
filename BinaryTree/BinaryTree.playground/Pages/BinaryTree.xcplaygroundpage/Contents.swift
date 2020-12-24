// 详细介绍：https://github.com/pro648/tips/blob/master/sources/%E4%BA%8C%E5%8F%89%E6%A0%91%20Binary%20Tree.md

import UIKit

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

example(of: "tree diagram") {
    print(tree)
}

example(of: "in-order traversal") {
    tree.traversalInOrder(visit: {
        print($0)
    })
}

example(of: "pre-order traversal") {
    tree.traversalPreOrder(visit: {
        print($0)
    })
}

example(of: "post-order traversal") {
    tree.traversalPostOrder(visit: {
        print($0)
    })
}
