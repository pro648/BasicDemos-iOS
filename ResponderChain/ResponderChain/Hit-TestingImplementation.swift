//
//  Hit-TestingImplementation.swift
//  ResponderChain
//
//  Created by pro648 on 2020/9/25.
//  

import UIKit

/// hit-testing 可能的实现
class Hit_TestingImplementation: UIView {
    
    /// hitTest(_:event:)  可能的实现
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // 只有允许用户交互、没有隐藏、可见度大于 0.01 时，才允许接收手势。
        guard isUserInteractionEnabled, !isHidden, alpha > 0.01 else { return nil }
        
        // 点击point不在视图中时，直接返回 nil。
        guard self.point(inside: point, with: event) else {
            return nil
        }
        
        // 逆序遍历子视图
        for subView in subviews.reversed() {
            let convertedPoint = subView.convert(point, from: self)
            let hitTestView = subView.hitTest(convertedPoint, with: event)
            
            // 首个非空子视图即为 first responder
            if let hitView = hitTestView {
                return hitView
            }
        }
        
        // 如果所有子视图都没有响应 hit-testing，则视图本身为 first responder。
        return self
    }
}
