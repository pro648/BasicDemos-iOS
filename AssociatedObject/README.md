###  关联对象 Associated Object 的本质

`category_t`结构体中存储了实例方法列表、类方法列表、协议列表、属性列表，但没有成员变量列表。因此，分类中不能直接添加成员变量，添加的属性只会声明getter、setter方法，不会生成对应的getter、setter实现和成员变量。

这篇文章提供了几种为分类添加成员变量的方案，比较其优劣，并分析了关联对象原理和源码。

![关联对象原理](https://github.com/pro648/tips/blob/master/sources/images/21/AssociatedObject.png)

详细介绍查看下面文章：

<https://github.com/pro648/tips/blob/master/sources/关联对象%20Associated%20Object%20的本质.md>

