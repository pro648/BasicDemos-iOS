### 原型模式 Prototype Pattern

原型模式（Prototype Pattern）属于创建型模式，Prototype 允许我们远离从 client 创建新实例的复杂操作，而采用复制已有对象，被复制的实例就是我们所称的原型。由于从零创建对象可能包含昂贵的操作，复制对象可以节省资源和时间。在需要时可以修改新复制对象的属性。

Prototype pattern 包含以下两部分：

![PrototypePattern](https://github.com/pro648/tips/wiki/images/PrototypePatternUML.png)

1. Copying：该协议声明了`copy()`方法。
2. Prototype：遵守`Copying`协议的 class。

详细介绍查看下面文章：

<https://github.com/pro648/tips/wiki/原型模式-Prototype-Pattern>

