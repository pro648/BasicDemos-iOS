// 详细介绍：https://github.com/pro648/tips/blob/master/sources/%E4%BA%8C%E5%8F%89%E6%90%9C%E7%B4%A2%E6%A0%91%20Binary%20Search%20Tree.md

import Foundation

public final class AVLNode<Element> {
    public var value: Element
    public var leftChild: AVLNode?
    public var rightChild: AVLNode?
    public var height = 0
    
    public init(value: Element) {
        self.value = value
    }
    
    public var balanceFactor: Int {
        leftHeight - rightHeight
    }
    
    public var leftHeight: Int {
        leftChild?.height ?? -1
    }
    
    public var rightHeight: Int {
        rightChild?.height ?? -1
    }
}

extension AVLNode: CustomStringConvertible {
    public var description: String {
        diagram(for: self)
    }
    
    private func diagram(for node: AVLNode?,
                         _ top: String = "",
                         _ root: String = "",
                         _ bottom: String = "") -> String {
        guard let node = node else {
            return root + "nil\n"
        }
        if node.leftChild == nil && node.rightChild == nil {
            return root + "\(node.value)\n"
        }
        return diagram(for: node.rightChild, top + " ", top + "┌──", top + "│ ")
            + root + "\(node.value)\n"
            + diagram(for: node.leftChild, bottom + "│ ", bottom + "└──", bottom + " ")
    }
}

extension AVLNode {
    
    /// 中序遍历
    public func traversalInOrder(visit: (Element) -> Void) {
        leftChild?.traversalInOrder(visit: visit)
        visit(value)
        rightChild?.traversalInOrder(visit: visit)
    }
    
    /// 前序遍历
    public func traversalPreOrder(visit: (Element) -> Void) {
        visit(value)
        leftChild?.traversalPreOrder(visit: visit)
        rightChild?.traversalPreOrder(visit: visit)
    }
    
    /// 后序遍历
    public func traversalPostOrder(visit: (Element) -> Void) {
        leftChild?.traversalPostOrder(visit: visit)
        rightChild?.traversalPostOrder(visit: visit)
        visit(value)
    }
    
    /// 前序遍历二叉树，会遍历空节点。
    public func traversePreOrder(visit: (Element?) -> Void) {
        visit(value)
        if let leftChild = leftChild {
            leftChild.traversePreOrder(visit: visit)
        } else {
            visit(nil)
        }
        
        if let rightChild = rightChild {
            rightChild.traversePreOrder(visit: visit)
        } else {
            visit(nil)
        }
    }
}
