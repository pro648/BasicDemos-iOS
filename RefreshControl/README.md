### 在UIScrollView、UICollectionView和UITableView中添加UIRefreshControl实现下拉刷新

从iOS 10开始，`UIScrollView`增加了一个`refreshControl`属性，用于把配置好的`UIRefreshControl`赋值给该属性，这样`UIScrollView`就有了下拉刷新功能。

因为`UITableView`和`UICollectionView`继承自`UIScrollView`，所以`UITableView`和`UICollectionView`也继承了`refreshControl`属性，也可以很方便的实现下拉刷新功能。

![RefreshControl](https://raw.githubusercontent.com/wiki/pro648/tips/images/RefreshControl.gif)

详细介绍查看下面文章：

<https://github.com/pro648/tips/wiki/在UIScrollView、UICollectionView和UITableView中添加UIRefreshControl实现下拉刷新>