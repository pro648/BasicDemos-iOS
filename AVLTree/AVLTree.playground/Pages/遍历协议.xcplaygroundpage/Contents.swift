//: [Previous](@previous)

/*:
 ### 遍历协议
 把常用功能封装到协议中，遵守协议即可获得相应功能。
 */

import Foundation

protocol TraversableBinaryNode {
    associatedtype Element
    var value: Element { get }
    var leftChild: Self? { get }
    var rightChild: Self? { get }
    
    func traverseInOrder(visit: (Element) -> Void)
    func traversePreOrder(visit: (Element) -> Void)
    func traversePostOrder(visit: (Element) -> Void)
}

extension AVLNode: TraversableBinaryNode {
    func traverseInOrder(visit: (Element) -> Void) {
        leftChild?.traverseInOrder(visit: visit)
        visit(value)
        rightChild?.traverseInOrder(visit: visit)
    }
    
    func traversePreOrder(visit: (Element) -> Void) {
        visit(value)
        leftChild?.traversePreOrder(visit: visit)
        rightChild?.traversePreOrder(visit: visit)
    }
    
    func traversePostOrder(visit: (Element) -> Void) {
        leftChild?.traversePreOrder(visit: visit)
        rightChild?.traversePreOrder(visit: visit)
        visit(value)
    }
}

example(of: "using TraversableBinaryNode") {
    var tree = AVLTree<Int>()
    for i in 0..<15 {
        tree.insert(i)
    }
    tree.root?.traverseInOrder(visit: {
        print($0)
    })
}
