//
//  BackgroundView.swift
//  CoreGraphics-1
//
//  Created by ad on 2021/10/3.
//

import UIKit

class BackgroundView: UIView {
    
//    let lightColor: UIColor = .orange
//    let darkColor: UIColor = .yellow
//    let patternSize: CGFloat = 200
    let lightColor = UIColor(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 242.0 / 255.0, alpha: 1.0)
    let darkColor = UIColor(red: 223.0 / 255.0, green: 255.0 / 255.0, blue: 247.0 / 255.0, alpha: 1.0)
    let patternSize = 30

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        guard let context = UIGraphicsGetCurrentContext() else {
            fatalError("\(#function): \(#line) Failed to get current context")
        }
        
        context.setFillColor(darkColor.cgColor)
        context.fill(rect)
        
        let drawSize = CGSize(width: patternSize, height: patternSize)
        
        // Insert code here
        // 创建图片上下文。
        UIGraphicsBeginImageContextWithOptions(drawSize, true, 0.0)
        // 获取上面创建上下文的引用。
        guard let drawingContext = UIGraphicsGetCurrentContext() else {
            fatalError("\(#function):\(#line) Failed to get current context.")
        }

        // Set the fill color for the new context.
        darkColor.setFill()
        drawingContext.fill(CGRect(x: 0, y: 0, width: drawSize.width, height: drawSize.height))
        
        let trianglePath = UIBezierPath()
        // 1
        trianglePath.move(to: CGPoint(x: drawSize.width / 2.0, y: 0))
        trianglePath.addLine(to: CGPoint(x: 0, y: drawSize.height / 2.0))
        trianglePath.addLine(to: CGPoint(x: drawSize.width, y: drawSize.height / 2.0))
        
        // 4
        trianglePath.move(to: CGPoint(x: 0, y: drawSize.height / 2.0))
        // 5
        trianglePath.addLine(to: CGPoint(x: drawSize.width / 2.0, y: drawSize.height))
        // 6
        trianglePath.addLine(to: CGPoint(x: 0, y: drawSize.height))
        
        // 7
        trianglePath.move(to: CGPoint(x: drawSize.width, y: drawSize.height / 2.0))
        // 8
        trianglePath.addLine(to: CGPoint(x: drawSize.width / 2.0, y: drawSize.height))
        // 9
        trianglePath.addLine(to: CGPoint(x: drawSize.width, y: drawSize.height))
        
        lightColor.setFill()
        trianglePath.fill()
        
        // 从当前context中提取图片
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            fatalError("""
            \(#function):\(#line) Failed to \
            get an image from current context.
            """)
        }
        // 关闭context后，context将恢复到视图自身context，所有绘制操作都会直接在视图中进行。
        UIGraphicsEndImageContext()

        UIColor(patternImage: image).setFill()
        context.fill(rect)
    }
}
