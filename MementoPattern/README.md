### 备忘录模式 Memento Pattern

备忘录模式（memento pattern）用于保存对象历史状态，以便后续可以恢复至任一状态。Memento pattern 是二十三种著名的 Gof design patterns 设计模式之一，属于 Behavioral Patterns。Memento pattern 由 Noah Thompson 和 Dr.Drew Clinkenbeard 为惠普产品创建。

Memento pattern 有以下三个部分：

![Memento Patter](https://raw.githubusercontent.com/wiki/pro648/tips/images/MementoPatternUML.png)

1. Originator：要保存或恢复的对象。
2. Memento：负责存储 originator 对象的内部状态。
3. CareTaker：请求 originator 保存对象，并得到 memento 响应。其负责持久化 memento，或把 memento 提供给 originator 以恢复到指定状态。

详细介绍查看下面文章：

<https://github.com/pro648/tips/wiki/备忘录模式-Memento-Pattern>