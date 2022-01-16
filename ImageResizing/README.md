### 图像下采样

这篇文章将介绍如何计算图片渲染后占用内存大小，其占用内存的根本原因，以及如何减小图片内存占用。

1. 图像内存占用。
2. 内存占用 ≠ 文件大小。
3. 图像渲染流程
   1. 图像类型
   2. 图像压缩
   3. 加载图像数据到内存
   4. 解码 decoding
4. 图像下采样方案
   1. UIGraphicsImageRender
   2. Core Graphics Context
   3. Image I/O
   4. Core Image
   5. vImage
5. 性能比较

详细介绍查看下面文章：

<https://github.com/pro648/tips/blob/master/sources/图像下采样.md>

