import Foundation

public extension RandomAccessCollection where Element: Comparable {
    func binarySearch(for value: Element, in range: Range<Index>? = nil) -> Index? {
        // 如果range为nil，搜索整个集合。
        let range = range ?? startIndex..<endIndex
        
        // 集合至少包含一个元素。
        guard range.lowerBound < range.upperBound else {
            return nil
        }
        
        // 查找中间索引
        let size = distance(from: range.lowerBound, to: range.upperBound)
        let middle = index(range.lowerBound, offsetBy: size / 2)
        
        if self[middle] == value {  // 如果与中间索引对应值匹配，直接返回。
            return middle
        } else if self[middle] > value {    // 如果没有匹配，继续查找左侧或右侧。
            return binarySearch(for: value, in: range.lowerBound..<middle)
        } else {
            return binarySearch(for: value, in: index(after: middle)..<range.upperBound)
        }
    }
}
