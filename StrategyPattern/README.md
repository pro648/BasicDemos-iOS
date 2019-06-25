### 策略模式 Strategy Pattern

策略模式 strategy pattern 属于 behavioral pattern。Strategy pattern 定义了一系列可互换替代的对象，可以在 runtime 时设置或切换。策略模式包含以下三部分：

![strategy pattern](https://raw.githubusercontent.com/wiki/pro648/tips/images/StrategyPatternUML.png)

- 使用策略模式的对象：通常为视图控制器，也可以是任何有互换替代 (interchangeable) 需求的对象。

- Strategy protocol：每种策略都必须遵守的协议。
- Strategies：遵守 strategy protocol 协议的对象，相互间可互换代替。

详细介绍查看下面文章：

<https://github.com/pro648/tips/wiki/策略模式-Strategy-Pattern>

##### Requirements

iOS 12.0+

Xcode 10.2

Swift 5.0