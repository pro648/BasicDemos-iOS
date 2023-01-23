### NSCache的使用

在app的生命周期中，有时需要保存、读取一些临时数据。根据需求不同，可能保存到磁盘上，也可能只存储在内存中。Apple提供的`NSCache`类提供了使用key-value将对象缓存到内存的方案。

`NSCache`有以下优点：

- 只在内存存储数据。如果app被杀死，占用的内存会被释放，不会持久化到磁盘。
- key-value对机制与`Dictionary`非常像，可以很方便的读取、保存数据。与`Dictionary`不同的是key不会被拷贝，更为高效。
- 可以设置自动删除缓存的策略，也可以主动驱逐缓存中对象。
- 线程安全。

只有下面一点不够完美之处：

- `NSCache`是Objective-C API，Key和Value都必须是Class类型。Swift中的`String`是struct类型，ObjC中的`NSString`是Class类型，在Swift中使用`NSCache`时，key不能时String类型。

`NSCache`用来缓存创建成本比较高，但在需要时可以重新创建的对象。例如，向用户展示的图片。下载、解码图片耗费时间和流量，再次展示同一张图片时如果再下载一次体验会很差，这时可以用缓存存储图片。内存告急时清理掉缓存中图片，再次展示时通过网络下载图片。

详细介绍查看下面文章：

<https://github.com/pro648/tips/blob/master/sources/NSCache%E7%9A%84%E4%BD%BF%E7%94%A8.md>

