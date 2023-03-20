### 协议、泛型和Existential Container

上一篇文章[Swift方法调用](https://github.com/pro648/tips/blob/master/sources/Swift方法调用.md)介绍了Swift的函数派发方式，Swift支持静态派发、虚表派发和消息机制三种派发方式。其中，虚表派发由Swift 面向对象的底层支持。这篇文章是我学习Swift面向协议编程（Protocol oriented programming，简写为POP）、泛型底层实现的记录。

下面两个函数有什么区别？

```
protocol Drivable {
    func drive()
    var numberOfWheels: Int { get }
}

func startTraveling(with transportation: Drivable) { }

func startTraveling<D: Drivable>(with transportation: D) { }
```

上述两个函数`startTraveling`的功能是一样的，没有做任何事情，但背后实现的原理是不同的。这篇文章将介绍其区别。

详细介绍查看下面文章：

<https://github.com/pro648/tips/blob/master/sources/%E5%8D%8F%E8%AE%AE%E3%80%81%E6%B3%9B%E5%9E%8B%E5%92%8CExistential%20Container.md>
