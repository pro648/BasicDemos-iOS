import Foundation

// 没有遵守LSP
/*
public class Rectangle {
    public var width: Int
    public var height: Int
    
    public init(width: Int, height: Int) {
        self.width = width
        self.height = height
    }
    
    public func area() -> Int {
        return width * height
    }
}
 */

public class Rectangle: Geometrics {
    public var width: Int
    public var height: Int
    
    public init(width: Int, height: Int) {
        self.width = width
        self.height = height
    }
    
    public func area() -> Int {
        return width * height
    }
}

//extension Rectangle: Geometrics {
//    public func area() -> Int {
//        return width * height
//    }
//}
