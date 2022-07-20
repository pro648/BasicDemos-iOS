### 里氏替换原则

这是SOLID五大原则的第三篇学习笔记： 里氏替换原则 Liskov Substitution Principle。

Barbara Liskov对里氏替换原则的定义是：

> "If for each object o1 of type S there is an object o2 of type T, such that for all programs P defined in terms of T, the behavior of P is unchanged when o1 is substituted for o2 then S is a subtype of T."
>
> 有S类型的对象o1，T类型的对象o2，S是T的子类，程序P接受输入T。当使用S替换T后，程序行为不会发生变化。

如果不看其具体定义，可能更容易理解，特别是第一次学习里氏替换原则。下面是一种更容易理解的描述：

> 程序引用了一个基类，也必须能够使用该基类的派生类，而其行为不能有变化，程序也不应知道派生类的存在。

上一篇文章[开闭原则](https://github.com/pro648/tips/blob/master/sources/%E5%BC%80%E9%97%AD%E5%8E%9F%E5%88%99.md)介绍了软件实体应对扩展开放，对修改关闭，这样代码更容易维护、重用。此外，还应使用抽象，例如继承、接口。

这篇文章将聚焦继承，以展示遵守LSP的优势，也会演示违背LSP原则带来的问题。当违背了LSP原则的时候，一般也会违背OCP，这些原则是关联的。

详细介绍查看下面文章：

<https://github.com/pro648/tips/blob/master/sources/%E9%87%8C%E6%B0%8F%E6%9B%BF%E6%8D%A2%E5%8E%9F%E5%88%99.md>

