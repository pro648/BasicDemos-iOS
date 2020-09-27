//
//  HitTestSlop.swift
//  ResponderChain
//
//  Created by pro648 on 2020/9/27.
//  

import UIKit

// 修改 UIButton 可点击区域

struct AssociateKeys {
    static var topKey: UInt8 = 0
    static var leftKey: UInt8 = 1
    static var bottomKey: UInt8 = 2
    static var rightKey: UInt8 = 3
}

protocol HitTestSlopProtocol {
    func expand(edgeInset hitTestSlop: UIEdgeInsets)
}

extension UIButton: HitTestSlopProtocol {
    func expand(edgeInset hitTestSlop: UIEdgeInsets) {
        objc_setAssociatedObject(self, &AssociateKeys.topKey, hitTestSlop.top, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        objc_setAssociatedObject(self, &AssociateKeys.leftKey, hitTestSlop.left, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        objc_setAssociatedObject(self, &AssociateKeys.bottomKey, hitTestSlop.bottom, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        objc_setAssociatedObject(self, &AssociateKeys.rightKey, hitTestSlop.right, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }

    private func slop() -> UIEdgeInsets {
        guard let topValue = objc_getAssociatedObject(self, &AssociateKeys.topKey) as? CGFloat,
              let leftValue = objc_getAssociatedObject(self, &AssociateKeys.leftKey) as? CGFloat,
              let bottomValue = objc_getAssociatedObject(self, &AssociateKeys.bottomKey) as? CGFloat,
              let rightValue = objc_getAssociatedObject(self, &AssociateKeys.rightKey) as? CGFloat else { return .zero}
        
        return UIEdgeInsets(top: topValue, left: leftValue, bottom: bottomValue, right: rightValue)
    }
    
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let insets = slop()
        
        if insets == .zero {
            // Safer to use UIView's point(inside:with:) if we can.
            return super.point(inside: point, with: event)
        } else {
            return bounds.inset(by: insets).contains(point)
        }
    }
}
