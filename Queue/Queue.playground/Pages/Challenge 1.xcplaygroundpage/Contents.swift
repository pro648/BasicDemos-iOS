//: [Previous](@previous)

/*:
 ## 记录游戏次序
 
 假设你在和朋友玩游戏，但大家都记不住该谁玩了。可以创建一个管理者，记录游戏次序。
 队列数据结构适合解决上述问题。
 */

import Foundation

protocol BoardGameManager {
    associatedtype Player
    mutating func nextPlayer() -> Player?
}

extension QueueLinkedList: BoardGameManager {
    public typealias Player = T
    
    public func nextPlayer() -> T? {
        // 通过dequeue获取下一个选手，如果获取不到，直接返回空。
        guard let person = dequeue() else { return nil }
        
        // enqueue 同一位选手，会将其添加到尾部。
        enqueue(person)
        return person
    }
}

var queue = QueueLinkedList<String>()
queue.enqueue("Vincent")
queue.enqueue("Remel")
queue.enqueue("Lukiih")
queue.enqueue("Allison")
print(queue)

print("==== boardgame ====")
queue.nextPlayer()
print(queue)
queue.nextPlayer()
print(queue)
queue.nextPlayer()
print(queue)
queue.nextPlayer()
print(queue)

//: [Next](@next)
