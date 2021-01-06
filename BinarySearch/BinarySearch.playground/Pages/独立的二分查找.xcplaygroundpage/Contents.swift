//: [Previous](@previous)
/*:
 ### 将二分查找算法作为独立函数
 之前，将 binary search 算法作为`RandomAccessCollection`的extension使用，但由于二分查找只适用于有序数组，将该算法暴露到`RandomAccessCollection`协议可能导致误用。如何将其作为独立函数？
 */

import Foundation

func binarySearch<Elements: RandomAccessCollection>(for element: Elements.Element, in collection: Elements, in range: Range<Elements.Index>? = nil) -> Elements.Index? where Elements.Element: Comparable {
    let range = range ?? collection.startIndex..<collection.endIndex
    guard range.lowerBound < range.upperBound else {
        return nil
    }
    let size = collection.distance(from: range.lowerBound, to: range.upperBound)
    let middle = collection.index(range.lowerBound, offsetBy: size / 2)
    if collection[middle] == element {
        return middle
    } else if collection[middle] > element {
        return binarySearch(for: element, in: collection, in: range.lowerBound..<middle)
    } else {
        return binarySearch(for: element, in: collection, in: collection.index(after: middle)..<range.upperBound)
    }
}

let array = [1, 4, 6, 8, 11, 12, 18, 64, 80, 101]
let binarySearch11 = array.binarySearch(for: 11)
print("binarySearch(for:): \(String(describing: binarySearch11))")


//: [Next](@next)
