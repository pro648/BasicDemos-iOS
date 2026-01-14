//: [Previous](@previous)

import Foundation

struct ColorPalette: Codable {
    let colors: [String]
    
    init(colors: [String]) {
        self.colors = colors
    }
    
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        var colorArray: [String] = []
        
        // 按顺序读取
        while !container.isAtEnd {
            let color = try container.decode(String.self)
            colorArray.append(color)
        }
        colors = colorArray
    }
    
    func encode(to encoder: Encoder) throws {
        // 获取无键容器
        var container = encoder.unkeyedContainer()
        
        // 按顺序写入值（无键名）
        for color in colors {
            try container.encode(color)
        }
    }
}

let colorPalette = ColorPalette(colors: ["red", "blue", "yellow"])
let encoder = JSONEncoder()
let data = try encoder.encode(colorPalette)
if let jsonStr = String(data: data, encoding: .utf8) {
    print("jsonStr: \(jsonStr)")
}




//: [Next](@next)
