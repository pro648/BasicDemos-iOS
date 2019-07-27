### 适配器模式 Adapter Pattern

适配器模式（Adapter Pattern）属于行为型模式（Behavioral Pattern），适配器模式也称为包装（Wrapper）。Adapter pattern 将类接口转换为客户端期望的其他类型接口，让接口不兼容的类一起工作。此模式可以帮助重新利用已有的类。

Adapter pattern 涉及以下四个组成部分：

![AdapterPatternUML](https://github.com/pro648/tips/wiki/images/AdapterPatternUML.png)

1. Object using an adapter：使用适配器的对象，即依赖新协议的对象。
2. New protocol：需要使用的协议。
3. Legacy object：声明协议前已经存在，无法直接修改该对象接口。
4. Adapter：遵守 New protocol，并将调用传递给 legacy object。

详细介绍查看下面文章：

<https://github.com/pro648/tips/wiki/适配器模式-Adapter-Pattern>

