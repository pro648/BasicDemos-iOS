import UIKit

// 详细介绍：https://github.com/pro648/tips/blob/master/sources/%E9%87%8C%E6%B0%8F%E6%9B%BF%E6%8D%A2%E5%8E%9F%E5%88%99.md

//let square = Square(width: 10, height: 10)
//let rectangle: Rectangle = square
//
//rectangle.height = 7
//rectangle.width = 5
//
//print(rectangle.area())

let rectangle: Geometrics = Rectangle(width: 10, height: 10)
print(rectangle.area())

let rectangle2: Geometrics = Square(edge: 5)
print(rectangle2.area())


//func draw(shape: Shape) {
//    if let square = shape as? SquareShape {
//        square.drawSquare()
//    } else if let circle = shape as? CircleShape {
//        circle.drawCircle()
//    }
//}

func draw(shape: Shape) {
    shape.draw()
}

let squareShape: Shape = SquareShape()
draw(shape: squareShape)
