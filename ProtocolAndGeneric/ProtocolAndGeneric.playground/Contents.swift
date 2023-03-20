import UIKit

// 继承多态
/*
 class Drawable {
 func draw() { }
 }
 
 class Point: Drawable {
 var x, y: Double
 
 override func draw() { }
 
 init(x: Double, y: Double) {
 self.x = x
 self.y = y
 }
 }
 
 class Line: Drawable {
 var x1, y1, x2, y2: Double
 
 override func draw() { }
 
 init(x1: Double, y1: Double, x2: Double, y2: Double) {
 self.x1 = x1
 self.y1 = y1
 self.x2 = x2
 self.y2 = y2
 }
 }
 
 let point = Point(x: 1, y: 2)
 let line = Line(x1: 1, y1: 2, x2: 3, y2: 4)
 
 var drawables: [Drawable] = [point, line]
 for d in drawables {
 d.draw()
 
 print("Pointer size: \(MemoryLayout.size(ofValue: d))")
 }
 */

/*
// 协议类型
protocol Drawable {
    func draw()
}
struct Point : Drawable {
    var x, y: Double
    func draw() {
        
    }
}
struct Line : Drawable {
    var x1, y1, x2, y2: Double
    func draw() {
        
    }
}

class Square: Drawable {
    var width: Double
    func draw() {
        
    }
    init(width: Double) {
        self.width = width
    }
}

let point = Point(x: 1, y: 2)
let line = Line(x1: 1, y1: 2, x2: 3, y2: 4)
let square = Square(width: 1)

print("point size: \(MemoryLayout.size(ofValue: point))")
print("line size: \(MemoryLayout.size(ofValue: line))")
print("square size: \(MemoryLayout.size(ofValue: square))")

var drawables: [Drawable] = [point, line, square]
for d in drawables {
    d.draw()
    print("d size: \(MemoryLayout.size(ofValue: d))")
}
*/

// 泛型结构体
struct WrapperStruct<T> {
    let value: T
}

var v1 = WrapperStruct(value: 42)
var v2 = WrapperStruct(value: (42, 43))

print("Dump v1: \(Mems.memStr(ofVal: &v1))")
print("Dump v2: \(Mems.memStr(ofVal: &v2))")

// 泛型包含多个结构体
struct WrapperStruct2<T, U> {
    let value1: T
    let value2: U
}

var v3 = WrapperStruct2(value1: 42, value2: 43)
var v4 = WrapperStruct2(value1: (42, 43), value2: 44)
var v5 = WrapperStruct2(value1: 42, value2: (43, 44))
print("Dump v3: \(Mems.memStr(ofVal: &v3))")
print("Dump v4: \(Mems.memStr(ofVal: &v4))")
print("Dump v5: \(Mems.memStr(ofVal: &v5))")

// 泛型class
class WrapperClass<T> {
    let value: T
    
    init(_ value: T) {
        self.value = value
    }
}

var v6 = WrapperClass(42)
var v7 = WrapperClass((42, 43))
print("Dump v6: \(Mems.memStr(ofRef: v6))")
print("Dump v7: \(Mems.memStr(ofRef: v7))")


protocol Drawable {
    func draw()
}

struct Point : Drawable {
    func draw() {
        
    }
}
struct Line : Drawable {
    func draw() {
        
    }
}

func drawACopy<T: Drawable>(local : T) {
    local.draw()
}

let line = Line()
drawACopy(local: line)
// ...
let point = Point()
drawACopy(local: point)

// 泛型特化
func min<T: Comparable>(x: T, y: T) -> T {
    return y < x ? y : x
}

let a: Int = 1
let b: Int = 2
min(a, b)
