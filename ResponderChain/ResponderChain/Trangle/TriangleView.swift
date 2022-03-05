//
//  TriangleView.swift
//  ResponderChain
//
//  Created by ad on 2022/2/24.
//

import UIKit

class TriangleView: UIButton {
    
    private lazy var bezierPath: UIBezierPath = {
        let bezierPath = UIBezierPath()
        bezierPath.lineWidth = 2.0
        let padding = 10.0
        bezierPath.move(to: CGPoint(x: bounds.size.width / 2.0, y: padding))
        bezierPath.addLine(to: CGPoint(x: bounds.size.width - padding, y: bounds.size.height - padding))
        bezierPath.addLine(to: CGPoint(x: padding, y: bounds.size.height - padding))
        bezierPath.close()
        return bezierPath
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .lightGray
        setTitle("Triangle", for: .normal)
        addTarget(self, action: #selector(self.handleButtonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        UIColor.red.setStroke()
        UIColor.yellow.setFill()
        bezierPath.fill()
        bezierPath.stroke()
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let result = super.hitTest(point, with: event) else { return nil}
        
        if result != self {
            return result
        }
        
        if bezierPath.contains(point) {
            return result
        } else {
            return nil
        }
    }
    
    @objc private func handleButtonTapped(_ sender: UIButton) {
        print("\(#line) \(#function)")
    }
}
