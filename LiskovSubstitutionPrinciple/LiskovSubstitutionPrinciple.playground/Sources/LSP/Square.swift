import Foundation

// 没有遵守LSP
/*
public class Square: Rectangle {
    public override var width: Int {
        didSet {
            super.height = width
        }
    }
    
    public override var height: Int {
        didSet {
            super.width = height
        }
    }
}
 */

public class Square {
    public var edge: Int
    
    public init(edge: Int) {
        self.edge = edge
    }
}

extension Square: Geometrics {
    public func area() -> Int {
        return edge * edge
    }
}
