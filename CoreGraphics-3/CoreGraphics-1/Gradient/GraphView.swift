//
//  GraphView.swift
//  CoreGraphics-1
//
//  Created by ad on 2021/9/18.
//

import UIKit

class GraphView: UIView {
    
    private enum Constants {
        static let cornerRadiusSize = CGSize(width: 8.0, height: 8.0)
        static let margin: CGFloat = 20.0
        static let topBorder: CGFloat = 60.0
        static let bottomBorder: CGFloat = 50.0
        static let colorAlpha: CGFloat = 0.3
        static let circleDiameter: CGFloat = 5.0
    }
    
    var startColor = UIColor(red: 250.0 / 255.0, green: 233.0 / 255.0, blue: 222.0 / 255.0, alpha: 1.0)
    var endColor = UIColor(red: 252.0 / 255.0, green: 79.0 / 255.0, blue: 8.0 / 255.0, alpha: 1.0)
    var graphPoints = [4, 2, 6, 4, 5, 8, 3]

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        let width = rect.width
        let height = rect.height
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: .allCorners, cornerRadii: Constants.cornerRadiusSize)
        path.addClip()
        
        // Drawing code
        guard let context = UIGraphicsGetCurrentContext() else { return }
        let colors = [startColor.cgColor, endColor.cgColor]
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        // colors的每个位置
        let colorLocations: [CGFloat] = [0.0, 1.0]
        
        // 创建gradient
        guard let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: colorLocations) else { return }
        
        let startPoint = CGPoint.zero
        let endPoint = CGPoint(x: 0, y: bounds.height)
        // 绘制gradient
        context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: [])
        
        // Calculate the x point
        let margin = Constants.margin
        let graphWidth = width - margin * 2 - 4
        let columnXPoint = { (column: Int) -> CGFloat in
            let spacing = graphWidth / CGFloat(self.graphPoints.count - 1)
            return CGFloat(column) * spacing + margin + 2
        }
        
        // Calculate the y point
        let topBorder = Constants.topBorder
        let bottomBorder = Constants.bottomBorder
        let graphHeight = height - topBorder - bottomBorder
        guard let maxValue = graphPoints.max() else { return }
        let columnYPoint = { (graphPoint: Int) -> CGFloat in
            let yPoint = CGFloat(graphPoint) / CGFloat(maxValue) * graphHeight
            return graphHeight + topBorder - yPoint
        }
        
        // Draw the line graph
        UIColor.white.setFill()
        UIColor.white.setStroke()
        
        // Set up the points line
        let graphPath = UIBezierPath()
        
        // Go to start of line
        graphPath.move(to: CGPoint(x: columnXPoint(0), y: columnYPoint(graphPoints[0])))
        
        // Add points for each item in the graphPoints array at the correct (x, y) for the point
        for i in 1..<graphPoints.count {
            let nextPoint = CGPoint(x: columnXPoint(i), y: columnYPoint(graphPoints[i]))
            graphPath.addLine(to: nextPoint)
        }
//        graphPath.stroke()
        
        // Create the clipping path for the graph gradient
        
        // 1. Save the state of the context (commented out for now)
        context.saveGState()
        
        // 2. Make a copy of the path
        guard let clippingPath = graphPath.copy() as? UIBezierPath else { return }
        
        // 3. Add lines to the copied path to complete the clip area.
        clippingPath.addLine(to: CGPoint(x: columnXPoint(graphPoints.count - 1), y: height))
        clippingPath.addLine(to: CGPoint(x: columnXPoint(0), y: height))
        clippingPath.close()
        
        // 4. Add the clipping path to the context
        clippingPath.addClip()
        
        // 5. Check clipping path - Temporary code
//        UIColor.green.setFill()
//        let rectPath = UIBezierPath(rect: rect)
//        rectPath.fill()
        // End temporary code
        
        // 使用y最大值作为渐变的起点
        let highestYPoint = columnYPoint(maxValue)
        let graphStartPoint = CGPoint(x: margin, y: highestYPoint)
        let graphEndPoint = CGPoint(x: margin, y: bounds.height)
        
        context.drawLinearGradient(gradient, start: graphStartPoint, end: graphEndPoint, options: [])
        context.restoreGState()
        
        // Draw the line on top of the clipped gradient
        graphPath.lineWidth = 2.0
        graphPath.stroke()
        
        // Draw the circles on top of the graph stroke
        for i in 0..<graphPoints.count {
            var point = CGPoint(x: columnXPoint(i), y: columnYPoint(graphPoints[i]))
            point.x -= Constants.circleDiameter / 2
            point.y -= Constants.circleDiameter / 2
            
            let circle = UIBezierPath(ovalIn: CGRect(origin: point, size: CGSize(width: Constants.circleDiameter, height: Constants.circleDiameter)))
            circle.fill()
        }
        
        // Draw horizontal graph lines on the top of everything
        let linePath = UIBezierPath()
        
        // Top line
        linePath.move(to: CGPoint(x: margin, y: topBorder))
        linePath.addLine(to: CGPoint(x: width - margin, y: topBorder))
        
        // Center line
        linePath.move(to: CGPoint(x: margin, y: graphHeight / 2 + topBorder))
        linePath.addLine(to: CGPoint(x: width - margin, y: graphHeight / 2 + topBorder))
        
        // Bottom line
        linePath.move(to: CGPoint(x: margin, y: height - bottomBorder))
        linePath.addLine(to: CGPoint(x: width - margin, y: height - bottomBorder))
        let color = UIColor(white: 1.0, alpha: Constants.colorAlpha)
        color.setStroke()
        
        linePath.lineWidth = 1.0
        linePath.stroke()
    }
 
}
