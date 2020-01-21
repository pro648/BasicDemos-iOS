//
//  Balloon.swift
//  Timer
//
//  Created by pro648 on 2020/1/19.
//  Copyright © 2020 pro648. All rights reserved.
//

import UIKit

@IBDesignable class Balloon: UIView {
    override func draw(_ rect: CGRect) {
        let balloonColor = UIColor(named: "rw-green") ?? .green
        let cordColor = UIColor(named: "rw-dark") ?? .black
        
        let ovalPath = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 66, height: 93))
        balloonColor.setFill()
        ovalPath.fill()
        
        let trianglePath = UIBezierPath()
        trianglePath.move(to: CGPoint(x: 33, y: 81.5))
        trianglePath.addLine(to: CGPoint(x: 42.96, y: 98.75))
        trianglePath.addLine(to: CGPoint(x: 23.04, y: 98.75))
        trianglePath.close()
        balloonColor.setFill()
        trianglePath.fill()
        
        let cordPath = UIBezierPath()
        cordPath.move(to: CGPoint(x: 33.29, y: 98.5))
        cordPath.addCurve(to: CGPoint(x: 33.29, y: 98.5),
                          controlPoint1: CGPoint(x: 33.29, y: 126.5),
                          controlPoint2: CGPoint(x: 27.01, y: 114.06))
        cordPath.addCurve(to: CGPoint(x: 33.29, y: 157.61),
                          controlPoint1: CGPoint(x: 39.57, y: 138.94),
                          controlPoint2: CGPoint(x: 39.57, y: 145.17))
        cordPath.addCurve(to: CGPoint(x: 33.29, y: 182.5),
                          controlPoint1: CGPoint(x: 27.01, y: 170.06),
                          controlPoint2: CGPoint(x: 33.29, y: 182.5))
        cordColor.setStroke()
        cordPath.lineWidth = 1
        cordPath.stroke()
    }
}
