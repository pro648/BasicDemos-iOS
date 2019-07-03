### 生成器模式 Builder Pattern

生成器模式（Builder Pattern）又称为建造模式，是 Gang of Four design patterns 中二十三种设计模式之一，属于 creational patterns。

Builder pattern 通过逐步提供输入来创建复杂对象，而不是通过初始化程序预先要求所有输入。生成器模式包含以下三部分：

![BuilderPatternUML](https://github.com/pro648/tips/wiki/images/BuilderPatternUML.png)

1. Director：接受输入并与 builder 协调。通常为视图控制器，或视图控制器所使用的帮助程序。
2. Product：要创造的复杂对象。其可以是 struct 或 class，具体取决于所需引用类型。一般为 model，但也可以根据需要改变。
3. Builder：接受输入并负责创建 product。为了方便引用，一般为 class 类型。

详细介绍查看下面文章：

<https://github.com/pro648/tips/wiki/生成器模式-Builder-Pattern>

