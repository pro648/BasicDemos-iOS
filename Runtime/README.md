### Runtime从入门到进阶

Objective-C 语言尽可能将决策从编译时间、链接时间推迟到运行时。只要有可能，它就会动态地执行任务。这意味着 Objective-C 不仅需要编译器，还需要运行时系统（runtime system）执行编译的代码。Objective-C 的动态性就是由 runtime 来支撑和实现的。

借助 runtime 可以实现很多功能，如字典转模型（MJExtension），查看私有成员变量，替换方法实现（method swizzling），为分类增加属性（associated objects）等。[JSPatch](https://github.com/bang590/JSPatch)热更新也是利用了 runtime，以便实现动态添加、改变方法实现。

这个demo包含[Runtime从入门到进阶一](https://github.com/pro648/tips/wiki/Runtime%E4%BB%8E%E5%85%A5%E9%97%A8%E5%88%B0%E8%BF%9B%E9%98%B6%E4%B8%80)、[Runtime从入门到进阶二](https://github.com/pro648/tips/wiki/Runtime%E4%BB%8E%E5%85%A5%E9%97%A8%E5%88%B0%E8%BF%9B%E9%98%B6%E4%BA%8C)两篇文章的源码。文章涉及内容如下：

- Runtime 预览
- 对象和类
  - 对象 object
  - 类 Class
  - 元类 meta class
  - Method
- 消息发送
- 动态方法解析
- 消息转发
  - 快速转发
  - 常规转发
- 具体应用
  - 交换方法 Method Swizzling
  - 关联对象 Associated Objects
  - 创建类
  - 查看私有成员变量
- 常见问题
  - super的本质
  - isKindOf: isMemberOf:

详细介绍查看下面文章：

<https://github.com/pro648/tips/wiki/Runtime从入门到进阶一>

<https://github.com/pro648/tips/wiki/Runtime从入门到进阶二>