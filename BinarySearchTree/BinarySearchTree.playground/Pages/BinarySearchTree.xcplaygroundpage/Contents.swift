/*:
 ### 二叉搜素树
 - 如果任意节点的左子树不为空，则左子树上所有节点的值小于它的根节点的值。
 - 如果任意节点的右子树不为空，则右子树上所有节点的值均大于或等于它的根节点的值。
 - 任意节点的左、右子树也分别为二叉搜索树。
 
 [查看详细介绍](https://github.com/pro648/tips/blob/master/sources/%E4%BA%8C%E5%8F%89%E6%90%9C%E7%B4%A2%E6%A0%91%20Binary%20Search%20Tree.md)
 */

import UIKit

//example(of: "building a BST") {
//    var bst = BinarySearchTree<Int>()
//    for i in 0..<5 {
//        bst.insert(i)
//    }
//    print(bst)
//}

var exampleTree: BinarySearchTree<Int> {
    var bst = BinarySearchTree<Int>()
    bst.insert(3)
    bst.insert(1)
    bst.insert(4)
    bst.insert(0)
    bst.insert(2)
    bst.insert(5)
    return bst
}

example(of: "building a BST") {
    print(exampleTree)
}

example(of: "removing a node") {
    var tree = exampleTree
    print("Tree before removal:")
    print(tree)
    tree.remove(3)
    print("Tree after removing root:")
    print(tree)
}
