import Foundation

public class BinaryNode<Element> {
    public var value: Element
    public var leftChild: BinaryNode?
    public var rightChild: BinaryNode?
    
    public init(value: Element) {
        self.value = value
    }
}

extension BinaryNode: CustomStringConvertible {
    public var description: String {
        diagram(for: self)
    }
    
    private func diagram(for node: BinaryNode?,
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

extension BinaryNode {
    
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
