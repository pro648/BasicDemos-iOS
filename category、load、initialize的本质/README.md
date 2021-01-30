###  分类category、load、initialize的本质和源码分析

 Objective-C 2.0 中提供的分类category新特性，可以动态的为已有类添加新行为。Category 有以下几个用途：

- 为已有的类添加新行为。此时，无需原来类的源码，也无需继承原来的类。例如，为 Cocoa Touch framework添加分类方法。添加的分类方法会被子类继承，在运行时和原始方法没有区别。
- 把类的实现根据功能划分到不同文件。
- 声明私有方法。

分类是运行时将自身方法、属性、协议合并到类对象、元类对象中。调用方法时优先调用分类的方法，多个分类实现同一方法，后编译的优先调用。

加载类时调用`+load`方法，类和分类的`+load`方法都会被调用。调用`+load`方法是通过找到函数指针，拿到函数地址直接调用。

首次向类发送消息时调用`+initialize`方法。`+initialize`是通过消息机制调用。类和分类都实现了`+initialize`方法时，只会调用分类的`+initialize`方法。如果类的父类还没有 initialize，则会先向父类发送`+initialize`消息。

详细介绍查看下面文章：

<https://github.com/pro648/tips/blob/master/sources/分类category、load、initialize的本质和源码分析.md>

