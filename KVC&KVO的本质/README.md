###  KVC、KVO的本质

添加观察者后，KVO利用runtime生成一个`NSKVONOtifying_`子类，并重写set方法。修改属性值时触发KVO。

![NSKVONotifying](https://raw.githubusercontent.com/pro648/tips/master/sources/images/21/KVO%26KVCNSKVONotifying_XXX.png)

使用KVC设值时，`setValue:forKey:`原理如下：

- 先查找`setKey:`、`_setKey:`方法，如果找到了，直接传递参数，调用方法；如果找不到，进入下一步。
- 查看`accessInstanceVariableDirectly`方法返回值，如果返回`NO`，即不允许访问成员变量，则调用`setValue:forUndefinedKey:`方法，并抛出`NSUnknownKeyException`异常；如果返回`YES`，进入下一步。
- 按照`_key`、`_isKey`、`key`、`isKey`顺序查找成员变量，如果找到了成员变量，直接赋值。如果找不到，则调用`setValue:forUndefinedKey:`方法，并抛出`NSUnknownKeyException`异常。

![setValueForKey](https://raw.githubusercontent.com/pro648/tips/master/sources/images/21/KVO%26KVCsetValue.png)

详细介绍查看下面文章：

<https://github.com/pro648/tips/blob/master/sources/KVC、KVO的本质.md>

