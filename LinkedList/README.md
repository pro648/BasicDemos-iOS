###  链表 LinkedList

链表（Linked list）是一种常见的基础数据结构，是一种线性表，但并不会按线性的顺序存储数据，而是在一个节点里存储下一个节点的指针。由于无需顺序存储，链表在插入时复杂度可以达到`O(1)`，比顺序表快很多，但是查找一个节点或访问特定编号的节点需`O(n)`的时间，而顺序表相应的时间复杂度分别是`O(logn)`和`O(1)`。

内容涉及以下这些方面：

1. 链表分类
2. 节点 Node
3. 创建链表 LinkedList
4. 向链表添加节点
   1. push 操作
   2. append 操作
   3. insert(after:) 操作
   4. 时间复杂度
5. 移除链表的节点
   1. pop 操作
   2. removeLast 操作
   3. remove(after:) 操作
   4. 时间复杂度
6. 值语义和写时拷贝
7. 优化 COW
   1. isKnownUniquelyReferenced
   2. 共享节点
   3. 开启 COW 时移除节点会产生错误
8. 链表相关算法题
   1. 逆序打印链表节点
   2. 查找链表的中间节点
   3. 反转链表
   4. 合并两个有序链表
   5. 删除链表中等于给定值的所有节点

详细介绍查看下面文章：

<https://github.com/pro648/tips/blob/master/sources/链表%20LinkedList.md>

