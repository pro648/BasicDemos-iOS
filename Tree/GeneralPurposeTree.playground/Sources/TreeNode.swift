import Foundation

public class TreeNode<T> {
    public var value: T
    public var children: [TreeNode] = []
    public weak var parent: TreeNode?
    
    public init(_ value: T) {
        self.value = value
    }
    
    /// 向当前节点添加子节点
    /// - Parameter child: 要添加的子节点
    public func add(_ child: TreeNode) {
        children.append(child)
    }
}

extension TreeNode {
    /// 深度优先遍历
    public func forEachDepthFirst(visit: (TreeNode) -> Void) {
        visit(self)
        children.forEach({
            // 使用递归遍历
            $0.forEachDepthFirst(visit: visit)
        })
    }
}

extension TreeNode {
    /// 层序遍历
    public func forEachLevelOrder(visit: (TreeNode) -> Void) {
        visit(self)
        var queue = Queue<TreeNode>()
        children.forEach({
            queue.enqueue($0)
        })
        
        while let node = queue.dequeue() {
            visit(node)
            node.children.forEach{ queue.enqueue($0)}
        }
    }
}

extension TreeNode where T: Equatable {
    public func search(_ value: T) -> TreeNode? {
        var result: TreeNode?
        forEachDepthFirst { (node) in
            if node.value == value {
                result = node
            }
        }
        return result
    }
}
