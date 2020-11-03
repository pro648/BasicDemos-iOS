//: [Previous](@previous)

// 逆序打印链表节点

func printInReverse<T>(_ list: LinkedList<T>) {
    printInReverse(list.head)
}

private func printInReverse<T>(_ node: Node<T>?) {
    // node 为nil时，已经递归到了 tail。
    guard let node = node else { return }
    
    print("Before")
    
    // 通过递归构建调用堆栈，
    printInReverse(node.next)
    
    // 只有递归结束后，才会执行下面输出。
    print("After")
    print(node.value)
}

example(of: "printing in reverse") {
    var list = LinkedList<Int>()
    list.push(3)
    list.push(2)
    list.push(1)
    
    print("original list: \(list)")
    print("Printing in reverse:")
    printInReverse(list)
}

//:[Next](@next)
