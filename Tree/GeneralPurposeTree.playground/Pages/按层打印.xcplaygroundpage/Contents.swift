//: [Previous](@previous)

import Foundation

// 创建树
// 根节点
let tree = TreeNode(15)

// 第二层
let one = TreeNode(1)
tree.add(one)
let seventeen = TreeNode(17)
tree.add(seventeen)
let twenty = TreeNode(20)
tree.add(twenty)

// 第三层
let one2 = TreeNode(1)
let five = TreeNode(5)
let zero = TreeNode(0)
one.add(one2)
one.add(five)
one.add(zero)
let two = TreeNode(2)
seventeen.add(two)
let five2 = TreeNode(5)
let seven = TreeNode(7)
twenty.add(five2)
twenty.add(seven)

func printEachLevel<T>(for tree: TreeNode<T>) {
  var queue = Queue<TreeNode<T>>()
  var nodesLeftInCurrentLevel = 0
  
  queue.enqueue(tree)
  while !queue.isEmpty {
    nodesLeftInCurrentLevel = queue.count
    // 循环打印一层
    while nodesLeftInCurrentLevel > 0 {
      guard let node = queue.dequeue() else { break }
      print("\(node.value)", terminator: " ")
      node.children.forEach { queue.enqueue($0) }
      nodesLeftInCurrentLevel -= 1
    }
    // 换行
    print()
  }
}

printEachLevel(for: tree)
