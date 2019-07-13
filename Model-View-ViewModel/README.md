### MVVM设计模式

Model-View-ViewModel（简称MVVM）是一种结构设计模式（structural design pattern），将对象分成三个不同的组：

![MVVMUML](https://raw.githubusercontent.com/wiki/pro648/tips/images/MVVMUML.png)

1. Models：持有用户数据。通常为 struct 或 class。
2. Views：在屏幕上显示视觉元素和控件。通常为`UIView`的子类。
3. View models：将模型转换为可在视图上直接显示的值。为了方便传递时进行引用，通常为 class。

详细介绍查看下面文章：

<https://github.com/pro648/tips/wiki/MVVM设计模式>

