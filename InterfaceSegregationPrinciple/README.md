### 接口隔离原则

这是SOLID五大原则的第四篇学习笔记： 接口隔离原则 Interface Segregation Principle（简写为ISP）。

接口隔离原则拆分庞大、臃肿的接口，成为更小、更具体的接口。这样client只需关心他们感兴趣的方法。这种缩小的接口也被称为角色接口。接口隔离原则的目的是系统解开耦合，从而容易重构、更改和重新部署。接口隔离原则是面向对象设计（OOD）五大原则（SOLID）之一，类似于在GRASP中的高内聚性。

Uncle Bob对其定义如下：

> Clients should not be forced to depend upon interfaces that they do not use.
>
> 不应强制客户依赖不使用的接口。

Uncle Bob常用的术语 fat interface，可以用来更清晰说明问题。Fat interface被认为是非内聚的接口，意味着接口提供了比语义术语更多的方法、功能。

Fat interface会带来与[单一职责](https://github.com/pro648/tips/blob/master/sources/%E5%8D%95%E4%B8%80%E8%81%8C%E8%B4%A3%E5%8E%9F%E5%88%99.md)类似的问题，如不必要的重构，额外的测试。这是因为接口耦合了太多功能，修改一个接口，所有实现了该协议的类都需要重新构建和测试。其因软件复杂度和规模而异，可能耗费很长时间。

详细介绍查看下面文章：

<https://github.com/pro648/tips/blob/master/sources/%E6%8E%A5%E5%8F%A3%E9%9A%94%E7%A6%BB%E5%8E%9F%E5%88%99.md>

