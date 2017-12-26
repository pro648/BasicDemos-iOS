### 一篇文章学会使用UIKit Dynamics

动力项(UIDynamicItem)是任何遵守`UIDynamicItem`协议的对象，相当于现实世界中的一个基本物体。自iOS 7开始，`UIView`和`UICollectionViewLayoutAttributes`默认实现了上述协议，你也可以自行实现该协议以便在自定义的类中使用动力效果动画(UIDynamicAnimator)，但很少需要这样做。

动力行为(UIDynamicBehavior)为动力项(UIDynamicItem)提供不同的2D物理动画，即指定`UIDynamicItem`应该如何运动、适用哪些物理规则。在这里`UIDynamicBehavior`类似一个抽象类，没有实现具体行为，因此一般使用这个类的子类来对一组`UIDynamicItem`应遵守的行为规则进行描述。`UIDynamicBehavior`可以独立作用，多个动力行为同时作用时遵守力的合成。

UIKit Dynamics库的核心在于`UIDynamicAnimator`，其封装了底层iOS物理引擎，是动力行为(UIDynamicBehavior)的容器，动力行为添加到容器内才会发挥作用，为动力项(UIDynamicItem)提供物理相关的功能和动画。

使用动力学(dynamics)的步骤是：配置一个或多个`UIDynamicBehavior`，其中为每个`UIDynamicBehavior`指定一个或多个`UIDynamicItem`，最后添加这些`UIDynamicBehavior`到`UIDynamicAnimator`。

在这个demo中，使用了UIGravityBehavior、UICollisionBehavior、UIPushBehavior、UIAttachmentBehavior、UISnapBehavior、UIFieldBehavior六种动力行为，详细介绍查看下面文章：

<https://github.com/pro648/tips/wiki/一篇文章学会使用UIKit-Dynamics>