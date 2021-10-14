import UIKit

let size = CGSize(width: 120, height: 200)

UIGraphicsBeginImageContextWithOptions(size, false, 0.0)

guard let context = UIGraphicsGetCurrentContext() else {
    fatalError("\(#function):\(#line) Failed to get current context.")
}

// Gold colors
let darkGoldColor = UIColor(red: 0.6, green: 0.5, blue: 0.15, alpha: 1.0)
let midGoldColor = UIColor(red: 0.86, green: 0.73, blue: 0.3, alpha: 1.0)
let lightGoldColor = UIColor(red: 1.0, green: 0.98, blue: 0.9, alpha: 1.0)

// 阴影
let shadow = UIColor.black.withAlphaComponent(0.80)
let shadowOffset = CGSize(width: 2.0, height: 2.0)
let shadowBlurRadius: CGFloat = 5

context.setShadow(offset: shadowOffset, blur: shadowBlurRadius, color: shadow.cgColor)

// 开启transparency layer
context.beginTransparencyLayer(auxiliaryInfo: nil)

// 红丝带
let lowerRibbonPath = UIBezierPath()
lowerRibbonPath.move(to: CGPoint(x: 0, y: 0))
lowerRibbonPath.addLine(to: CGPoint(x: 40, y: 0))
lowerRibbonPath.addLine(to: CGPoint(x: 78, y: 70))
lowerRibbonPath.addLine(to: CGPoint(x: 38, y: 70))
lowerRibbonPath.close()
UIColor.red.setFill()
lowerRibbonPath.fill()

// 搭扣
let claspPath = UIBezierPath(roundedRect: CGRect(x: 36, y: 62, width: 43, height: 20), cornerRadius: 5)
claspPath.lineWidth = 5
darkGoldColor.setStroke()
claspPath.stroke()

// 奖杯垂饰
let medallionPath = UIBezierPath(ovalIn: CGRect(x: 8, y: 72, width: 100, height: 100))
context.saveGState()
medallionPath.addClip()

let colors = [
    darkGoldColor.cgColor,
    midGoldColor.cgColor,
    lightGoldColor.cgColor
] as CFArray
guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: colors, locations: [0, 0.51, 1]) else {
    fatalError("""
        Failed to instantiate an instance \
        of \(String(describing: CGGradient.self))
        """)
}
//context.drawLinearGradient(gradient, start: CGPoint(x: 40, y: 40), end: CGPoint(x: 40, y: 162), options: [])
context.drawLinearGradient(gradient, start: CGPoint(x: 40, y: 40), end: CGPoint(x: 100, y: 160), options: [])
context.restoreGState()

// 创建transform
// 缩放、向右下平移
var transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
transform = transform.translatedBy(x: 15, y: 30)
medallionPath.lineWidth = 2.0

// 应用transform
medallionPath.apply(transform)
medallionPath.stroke()

// 蓝丝带
let upperRibbonPath = UIBezierPath()
upperRibbonPath.move(to: CGPoint(x: 68, y: 0))
upperRibbonPath.addLine(to: CGPoint(x: 108, y: 0))
upperRibbonPath.addLine(to: CGPoint(x: 78, y: 70))
upperRibbonPath.addLine(to: CGPoint(x: 38, y: 70))
upperRibbonPath.close()

UIColor.blue.setFill()
upperRibbonPath.fill()

// 数字1
let numberOne = "1" as NSString // 必现是NSString类型，否则无法使用draw(in:)
let numberOneRect = CGRect(x: 47, y: 100, width: 50, height: 50)
guard let font = UIFont(name: "Academy Engraved LET", size: 60) else {
    fatalError("""
      \(#function):\(#line) Failed to instantiate font \
      with name \"Academy Engraved LET\"
      """)
}
let numberOneAttributes = [
    NSAttributedString.Key.font: font,
    NSAttributedString.Key.foregroundColor: darkGoldColor
]
numberOne.draw(in: numberOneRect, withAttributes: numberOneAttributes)

// 关闭transparency layer
context.endTransparencyLayer()

// 从当前context中创建图片
let image = UIGraphicsGetImageFromCurrentImageContext()
UIGraphicsEndImageContext()
