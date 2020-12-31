//: [Previous](@previous)
/*:
 ### 树的子结构
 输入两棵二叉树A和B，判断B是不是A的子结构。空树不是任何一个树的子结构。

 B是A的子结构，即A中有出现和B结构、值相同的子树。
 */

import Foundation

extension BinaryNode where Element: Comparable {
    public static func isSubStructure(_ a: BinaryNode?, _ b: BinaryNode?) -> Bool {
        // 树a、b为空时，直接返回false。
        guard let a = a, let b = b else {
            return false
        }
        
        // 满足以下三种情况之一即可
        return recur(a, b) || isSubStructure(a.leftChild, b) || isSubStructure(a.rightChild, b)
    }

    private static func recur(_ a: BinaryNode?, _ b: BinaryNode?) -> Bool {
        // b为空时匹配完成，返回true。
        guard let b = b else { return true }
        // a 为空，或a、b值不相等，匹配失败。
        guard let a = a, a.value == b.value else { return false }
        
        // 继续匹配子树
        return recur(a.leftChild, b.leftChild) && recur(a.rightChild, b.rightChild)
    }
}

var three = BinaryNode(value: 3)
var two = BinaryNode(value: 2)
var four = BinaryNode(value: 4)
var one = BinaryNode(value: 1)

two.leftChild = one
two.rightChild = three
three.rightChild = four

if BinaryNode.isSubStructure(two, three) {
    print("yes")
} else {
    print("false")
}
