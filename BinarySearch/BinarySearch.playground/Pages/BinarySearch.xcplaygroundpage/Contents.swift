/*:
 ### 二分查找 Binary Search
 二分查找是最高效的算法之一，时间复杂度是`O(log n)`。与平衡的二叉搜索树复杂度一样。

 想要使用二分查找，需满足以下条件：

 - 集合必须能够在恒定时间查找任意索引的值。也就是集合需遵守`RandomAccessCollection`协议。
 - 集合必须是有序的。
 
 [查看详细介绍](https://github.com/pro648/tips/blob/master/sources/%E4%BA%8C%E5%88%86%E6%9F%A5%E6%89%BE%20Binary%20Search.md)
 */

import UIKit

let array = [1, 4, 6, 8, 11, 12, 18, 64, 80, 101]
let search11 = array.firstIndex(of: 11)
let binarySearch11 = array.binarySearch(for: 11)

print("firstIndex(of:): \(String(describing: search11))")
print("binarySearch(for:): \(String(describing: binarySearch11))")
