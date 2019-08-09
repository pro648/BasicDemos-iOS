### 迭代器模式 Iterator Pattern

迭代器模式（Iterator Pattern）属于行为型模式。Iterator pattern 提供了循环集合的标准方法。

Iterator pattern 包含以下两部分：

![IteratorPatternUML](https://raw.githubusercontent.com/wiki/pro648/tips/images/IteratorPatternUML.png)

1. IteratorProtocol：Swift 中的`IterableProtocol`协议定义了一个可以使用 for in 循环迭代的类型。
2. Iterator Object：想要进行迭代的对象。一般，Iterator object 不直接遵守`IteratorProtocol`协议，而是遵守`Sequence`协议。`Sequence`协议遵守`IteratorProtocol`协议。通过遵守`Sequence`协议可以直接获得许多高级函数，例如，`map`、`filter`等。

详细介绍查看下面文章：

<https://github.com/pro648/tips/wiki/迭代器模式-Iterator-Pattern>

