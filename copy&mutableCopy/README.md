### 深复制、浅复制、copy、mutableCopy

对象的拷贝有浅复制和深复制两种方式。浅复制只复制指向对象的指针，并不复制对象本身；深复制是直接复制整个对象到另一块内存中。即浅复制是复制指针，深复制是复制内容。

NSObject提供了`copy`和`mutableCopy` 方法，`copy`复制后对象是不可变对象（immutable），`mutableCopy`复制后的对象是可变对象（mutable），与原始对象是否可变无关。

#### 非集合类对象的`copy`与`mutableCopy`

非集合类对象指的是`NSString`、`NSNumber`之类的对象，深复制会复制引用对象的内容，而浅复制只复制引用这些对象的指针。

![string](https://raw.githubusercontent.com/wiki/pro648/tips/images/CopyObjectCopying.png)

非集合类对象的`copy`与`mutableCopy`：

- 对不可变对象执行`copy`操作，是指针复制，执行`mutableCopy`操作是内容复制。
- 对可变对象执行`copy`操作和`mutableCopy`操作都是内容复制。

#### 容器类对象的深复制、浅复制

容器类对象指`NSArray`、`NSDictionary`等。容器类对象的深复制、浅复制如下图所示：

![container](https://raw.githubusercontent.com/wiki/pro648/tips/images/CopyCollectionCopy.png)

复制集合时，该集合、集合内元素的可变性可能会受到影响。每种方法对任意深度集合中对象的可变性有稍微不同的影响。

1. `copyWithZone: `创建对象的*最外层 surface level*不可变，所有更深层次对象的可变性不变。
2. `mutableCopyWithZone: `创建对象的*最外层 surface level*可变，所有更深层次对象的可变性不变。
3. `initWithArray: copyItems: `第二个参数为`NO`，此时，所创建数组最外层可变性与初始化的可变性相同，所有更深层级对象可变性不变。
4. `initWithArray: copyItems: `第二个参数为`YES`，此时，所创建数组最外层可变性与初始化的可变性相同，下一层级是不可变的，所有更深层级对象可变性不变。
5. 归档、解档复制的集合，所有层级的可变性与原始对象相同。

详细介绍查看下面文章：

<https://github.com/pro648/tips/wiki/深复制、浅复制、copy、mutableCopy>

##### 系统要求

iOS 2.0+
