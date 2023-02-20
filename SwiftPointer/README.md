### Swift指针的使用

默认情况下，Swift是内存安全的，禁止直接访问内存空间，确保实体使用前已经初始化。同时，Swift也提供了一种不安全（unsafe）的方式，使用指针直接访问内存。

Unsafe不意味着危险的，无法正常工作的代码。相反，其意味着编译器不会保护你免于犯错，需要额外关注。

如果你需要与unsafe语言互操作（例如C语言）、提升运行时性能，或者只是想探究Swift内部实现，Swift提供的unsafe指针将会非常有用。这篇文章将会介绍如何使用指针，以及如何操作内存。

| 指针名称                      | 不安全 | 可写入 | 容器类型 | 遵守Strideable | 有类型 |
| ----------------------------- | ------ | ------ | -------- | -------------- | ------ |
| UnsafePointer<T>              | YES    | NO     | NO       | YES            | YES    |
| UnsafeMutablePointer<T>       | YES    | YES    | NO       | YES            | YES    |
| UnsafeBufferPointer<T>        | YES    | NO     | YES      | NO             | YES    |
| UnsafeMutableBufferPointer<T> | YES    | YES    | YES      | NO             | YES    |
| UnsafeRawPointer              | YES    | NO     | NO       | YES            | NO     |
| UnsafeMutableRawPointer       | YES    | YES    | NO       | YES            | NO     |
| UnsafeRawBufferPointer        | YES    | NO     | YES      | NO             | NO     |
| UnsafeMutableRawBufferPointer | YES    | YES    | YES      | NO             | NO     |

名称规则是：`Unsafe[Mutable][Raw][Buffer]Pointer[<T>]`，mutable表示可以向内存写入，raw表示原始数据、无类型，buffer表示像容器一样是内存集合，<T>表示泛型数据类型。

详细介绍查看下面文章：

<https://github.com/pro648/tips/blob/master/sources/Swift%E6%8C%87%E9%92%88%E7%9A%84%E4%BD%BF%E7%94%A8.md>

