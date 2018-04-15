### View Controller 转场

这个demo结合文章介绍了以下几种呈现视图控制器的方法：

- 使用segue自动显示视图控制器，segue会使用你在Interface Builder中配置的信息实例化并呈现视图控制器。下面是segue的几种类型：

  - Show：此segue调用`showViewController: sender:`方法显示新内容。对于大多数视图控制器，show segue 在源视图控制器上以modal方式呈现新内容。但`UISplitViewController`和`UINavigationController`类会重写`showViewController: sender:`方法，以根据自身设计处理呈现方式。如在`UINavigationController`中，视图控制器会被push到其导航堆栈。

  - Show Detail：此segue调用`showDetailViewController: sender:`方法显示新内容。Show Detail segue仅与嵌入在`UISplitViewController`对象内的视图控制器相关，此时分割视图用新内容替换detail controller。在其他视图控制器中，show detail会以modal形式呈现新内容。

  - Present Modally：此segue使用指定presentation styel和transition style以modal形式呈现新内容。

  - Present as Popover：在horizontally regular environment，视图控制器显示在弹出窗口中；在horizontally compact environment，视图控制器使用全屏模式显示。

    > Push、Modal、Popover、Replace这四种segue已经不推荐使用。

- 使用`showViewController:sender:`或`showDetailViewController:sender:`方法呈现视图控制器。该方法为视图控制器提供了自适应（adaptive）、灵活的呈现方式。这些方法让presenting view controller决定如何呈现视图控制器。例如：容器视图控制器会以子视图控制器的形式呈现新的控制器，而非默认的modal形式。

- 使用`presentViewController:animated:completion:`方法总是以modal形式呈现视图控制器。调用该方法的视图控制器可能不是最终处理呈现过程的视图控制器。例如：必须由全屏控制器呈现全屏控制器，如果当前presenting view controller不是全屏，UIKit将遍历视图层次结构，直到找到合适视图控制器。呈现完成后，UIKit更新`presentingViewController`、`presentedViewController`属性。

详细介绍查看下面文章：

<https://github.com/pro648/tips/wiki/View-Controller-转场>