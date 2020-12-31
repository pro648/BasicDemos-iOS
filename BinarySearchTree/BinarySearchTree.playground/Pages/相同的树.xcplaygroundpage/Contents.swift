//: [Previous](@previous)
/*:
 ### 是否是相同的树
 给定两个二叉树，编写一个函数来检验其是否相同。

 当且仅当两个二叉树结构完全相同，对应节点的值相同，才认为两个二叉树相同。因此，可以通过搜索的方式判断两个二叉树是否相同。
 */

import Foundation

extension BinarySearchTree: Equatable {
    public static func ==(lhs: BinarySearchTree, rhs: BinarySearchTree) -> Bool {
        isEqual(lhs.root, rhs.root)
    }
    
    private static func isEqual<Element: Equatable>( _ node1: BinaryNode<Element>?, _ node2: BinaryNode<Element>?) -> Bool {
        guard let leftNode = node1, let rightNode = node2 else { return node1 == nil && node2 == nil }
        
        return leftNode.value == rightNode.value && isEqual(leftNode.leftChild, rightNode.leftChild) && isEqual(leftNode.rightChild, rightNode.rightChild)
    }
}

var bst = BinarySearchTree<Int>()
bst.insert(3)
bst.insert(1)
bst.insert(4)
bst.insert(0)
bst.insert(2)
bst.insert(5)

print(bst)

var bst2 = BinarySearchTree<Int>()
bst2.insert(2)
bst2.insert(5)
bst2.insert(3)
bst2.insert(1)
bst2.insert(0)
bst2.insert(4)

if bst == bst2 {
    print("bst == bst2")
} else {
    print("bst != bst2")
}

//: [Next](@next)
