###  @autoclosure的使用

函数参数可以使用返回值类型相同的无参闭包替换。这种类型的闭包可以使用`@autoclosure`标记。使用`@autoclosure`标记后，闭包前后不需要添加大括号，自动闭包会自动添加大括号。使用`@autoclosure`标记后，传入的函数不会立即执行，会延迟到函数体内调用才执行。

详细介绍查看下面文章：

<https://github.com/pro648/tips/blob/master/sources/@autoclosure%E7%9A%84%E4%BD%BF%E7%94%A8.md>

