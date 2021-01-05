import Foundation

public struct AVLTree<Element: Comparable> {
    public private(set) var root: AVLNode<Element>?
    
    public init() {}
}

extension AVLTree: CustomStringConvertible {
    public var description: String {
        guard let root = root else { return "empty tree" }
        return String(describing: root)
    }
}

extension AVLTree {
    
    /// 插入元素
    public mutating func insert(_ value: Element) {
        root = insert(from: root, value: value)
    }
    
    private func insert(from node: AVLNode<Element>?, value: Element) -> AVLNode<Element> {
        // 如果节点为nil，则找到了插入点，返回节点，结束递归。
        guard let node = node else { return AVLNode(value: value) }
        
        // Element 遵守 Comparable，比较值大小。
        if value < node.value { // 值小于当前节点，继续与左子树比较。
            node.leftChild = insert(from: node.leftChild, value: value)
        } else {    // 大于等于当前节点值，继续与右子树比较。
            node.rightChild = insert(from: node.rightChild, value: value)
        }
        
        // 恢复平衡
        let balancedNode = balanced(node)
        balancedNode.height = max(balancedNode.leftHeight, balancedNode.rightHeight) + 1
        
        return balancedNode
    }
    
    /// 左旋
    private func leftRotate(_ node: AVLNode<Element>) -> AVLNode<Element> {
        // 节点右子树作为枢纽
        let pivot = node.rightChild!
        
        // 要旋转的节点会被设置为枢纽的左子树，pivot现在的左子树被设置为node的右子树。
        node.rightChild = pivot.leftChild
        pivot.leftChild = node
        
        // 更新pivot和node的高度
        node.height = max(node.leftHeight, node.rightHeight) + 1
        pivot.height = max(pivot.leftHeight, pivot.rightHeight) + 1
        
        // 返回 pivot，用以替换旋转的节点。
        return pivot
    }
    
    /// 右旋
    private func rightRotate(_ node: AVLNode<Element>) -> AVLNode<Element> {
        let pivot = node.leftChild!
        node.leftChild = pivot.rightChild
        pivot.rightChild = node
        
        node.height = max(node.leftHeight, node.rightHeight) + 1
        pivot.height = max(pivot.leftHeight, pivot.rightHeight) + 1
        
        return pivot
    }
    
    /// 先右旋，后左旋
    private func rightLeftRotate(_ node: AVLNode<Element>) -> AVLNode<Element> {
        guard let rightChild = node.rightChild else { return node }
        
        node.rightChild = rightRotate(rightChild)
        return leftRotate(node)
    }
    
    /// 先左旋、后右旋
    private func leftRightRotate(_ node: AVLNode<Element>) -> AVLNode<Element> {
        guard let leftChild = node.leftChild else { return node }
        
        node.leftChild = leftRotate(leftChild)
        return rightRotate(node)
    }
    
    /// 平衡
    private func balanced(_ node: AVLNode<Element>) -> AVLNode<Element> {
        switch node.balanceFactor {
        case 2: // 2表示左子树高度大于右子树高度
            if let leftChild = node.leftChild, leftChild.balanceFactor == -1 {
                return leftRightRotate(node)
            } else {
                return rightRotate(node)
            }
        case -2:    // -2表示右子树高度大于左子树高度
            if let rightChild = node.rightChild, rightChild.balanceFactor == 1 {
                return rightLeftRotate(node)
            } else {
                return leftRotate(node)
            }
        default:    // 节点已经平衡，无序调节。
            return node
        }
    }
    
    /// 查找
    public func contains(_ value: Element) -> Bool {
        var current = root
        
        // 只要节点不为空，继续查找。
        while let node = current {
            if node.value == value {    // 值相等时返回 true。
                return true
            }
            
            // 根据值大小，决定与左子树还是右子树比较。
            if value < node.value {
                current = node.leftChild
            } else {
                current = node.rightChild
            }
        }
        
        return false
    }
    
    public mutating func remove(_ value: Element) {
        root = remove(node: root, value: value)
    }
    
    private func remove(node: AVLNode<Element>?, value: Element) -> AVLNode<Element>? {
        guard let node = node else { return nil }
        
        if value == node.value {
            // 叶子节点直接返回nil，即移除。
            if node.leftChild == nil && node.rightChild == nil {
                return nil
            }
            
            // 度为一的节点，左子树为nil，返回右子树。
            if node.leftChild == nil {
                return node.rightChild
            }
            
            // 度为一的节点，右子树为nil，返回左子树。
            if node.rightChild == nil {
                return node.leftChild
            }
            
            // 度为二的节点。
            node.value = node.rightChild!.min.value
            node.rightChild = remove(node: node.rightChild, value: node.value)
            
        } else if value < node.value {
            node.leftChild = remove(node: node.leftChild, value: value)
        } else {
            node.rightChild = remove(node: node.rightChild, value: value)
        }
        
//        return node
        // 删除后恢复平衡
        let balancedNode = balanced(node)
        balancedNode.height = max(balancedNode.leftHeight, balancedNode.rightHeight) + 1
        return balancedNode
    }
}

private extension AVLNode {
    var min: AVLNode {
        leftChild?.min ?? self
    }
}
