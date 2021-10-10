//
//  CounterView.swift
//  CoreGraphics-1
//
//  Created by ad on 2021/9/12.
//

import UIKit

class CounterView: UIView {
    
    private struct Constants {
        static let numberOfGlasses = 8
        static let lineWidth: CGFloat = 5.0
        static let arcWidth: CGFloat = 76
        
        static var halfOfLineWidth: CGFloat {
            lineWidth / 2
        }
    }
    
    var counter = 5 {
        didSet {
            if counter <= Constants.numberOfGlasses {
                counterLabel.text = String(counter)
                
                setNeedsDisplay()
            }
        }
    }
    var outlineColor = UIColor(red: 34.0 / 255.0, green: 110.0 / 255.0, blue: 100.0 / 255.0, alpha: 1.0)
    var counterColor = UIColor(red: 87.0 / 255.0, green: 218.0 / 255.0, blue: 213.0 / 255.0, alpha: 1.0)
    
    lazy var counterLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 36)
        label.text = "8"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addAllSubviews()
        makeAllConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // 弧线的center
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        
        // 根据视图最大尺寸计算半径
        let radius = max(bounds.width, bounds.height)
        
        // 弧线起始弧度
        let startAngle: CGFloat = 3 * .pi / 4
        let endAngle: CGFloat = .pi / 4
        
        // 根据center、radius、angle创建贝塞尔曲线
        let path = UIBezierPath(arcCenter: center, radius: radius / 2 - Constants.arcWidth / 2, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        // 设置path宽度、颜色，最后stroke path
        path.lineWidth = Constants.arcWidth
        counterColor.setStroke()
        path.stroke()
        
        // 绘制外边缘
        
        // 计算弧度，确保其为正值。
        let angleDifference: CGFloat = 2 * .pi - startAngle + endAngle
        // 每杯水对应弧度
        let arcLengthPerGlass = angleDifference / CGFloat(Constants.numberOfGlasses)
        // 弧线终点弧度
        let outlineEndAngle = arcLengthPerGlass * CGFloat(counter) + startAngle
        
        //  绘制外边缘
        let outerArcRadius = bounds.width / 2 - Constants.halfOfLineWidth
        let outlinePath = UIBezierPath(arcCenter: center, radius: outerArcRadius, startAngle: startAngle, endAngle: outlineEndAngle, clockwise: true)
        
        // 绘制内边缘
        let innerArcRadius = bounds.width / 2 - Constants.arcWidth + Constants.halfOfLineWidth
        outlinePath.addArc(withCenter: center, radius: innerArcRadius, startAngle: outlineEndAngle, endAngle: startAngle, clockwise: false)
        
        // 关闭path
        outlinePath.close()
        
        outlineColor.setStroke()
        outlinePath.lineWidth = Constants.lineWidth
        outlinePath.stroke()
        
        // Counter View markers
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        // 1. 保存当前 state
        context.saveGState()
        outlineColor.setFill()
        
        let markerWidth: CGFloat = 5.0
        let markerSize: CGFloat = 10.0
        
        // 2. marker矩形位于左上角
        let markerPath = UIBezierPath(rect: CGRect(x: -markerWidth / 2, y: 0, width: markerWidth, height: markerSize))
        
        // 3. 将context平移到中心
        context.translateBy(x: rect.width / 2, y: rect.height / 2)
        
        for i in 1...Constants.numberOfGlasses {
            // 4. 保存位于中心的state
            context.saveGState()
            // 5. 计算旋转角度
            let angle = arcLengthPerGlass * CGFloat(i) + startAngle - .pi / 2
            // 旋转、平移。
            context.rotate(by: angle)
            context.translateBy(x: 0, y: rect.height / 2 - markerSize)
            
            // 6. 填充指示矩形
            markerPath.fill()
            // 7. 恢复至中心零角度位置，以便进行下一次的计算。
            context.restoreGState()
        }
        
        // 8. 恢复至初始状态，以便进行其它绘制。
        context.restoreGState()
    }
}

extension CounterView {
    private func addAllSubviews() {
        addSubview(counterLabel)
    }
    
    private func makeAllConstraints() {
        counterLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            counterLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            counterLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
}
