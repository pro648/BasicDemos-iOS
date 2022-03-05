//
//  MethodSwizzling.swift
//  ResponderChain
//
//  Created by pro648 on 2020/9/25.
//  

import UIKit

extension UIView{
    
    /// 通过交换系统的hitTest(_:event:)、pointInside(inside:event:)方法，增加输出调用该方法的类等信息，方便查看查找细节。
    public class func initializeMethod() {
        
        // hit-testing
        let originalHitSelector = #selector(UIView.hitTest(_:with:))
        let swizzleHitSelector = #selector(UIView.pr_hitTest(_:with:))
        
        guard let originalHitMethod = class_getInstanceMethod(self, originalHitSelector) else { return }
        guard let swizzleHitMethod = class_getInstanceMethod(self, swizzleHitSelector) else { return }
        
        let didAddHitMethod = class_addMethod(self, originalHitSelector, method_getImplementation(swizzleHitMethod), method_getTypeEncoding(swizzleHitMethod))
        if didAddHitMethod {
            class_replaceMethod(self, swizzleHitSelector, method_getImplementation(originalHitMethod), method_getTypeEncoding(swizzleHitMethod))
        } else {
            method_exchangeImplementations(originalHitMethod, swizzleHitMethod)
        }
        
        // pointInside
        let originalInsideSelector = #selector(UIView.point(inside:with:))
        let swizzleInsideSelector = #selector(UIView.pr_point(inside:with:))
        
        guard let originalInsideMethod = class_getInstanceMethod(self, originalInsideSelector) else { return }
        guard let swizzleInsideMethod = class_getInstanceMethod(self, swizzleInsideSelector) else { return }
        
        let didAddInsideMethod = class_addMethod(self, originalInsideSelector, method_getImplementation(swizzleInsideMethod), method_getTypeEncoding(swizzleInsideMethod))
        if didAddInsideMethod {
            class_replaceMethod(self, swizzleInsideSelector, method_getImplementation(originalInsideMethod), method_getTypeEncoding(swizzleInsideMethod))
        } else {
            method_exchangeImplementations(originalInsideMethod, swizzleInsideMethod)
        }
    }
    
    // 交换系统的hitTest(_:event:)方法，hit-Testing 时可以查看查找顺序。
    @objc public func pr_hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        print(NSStringFromClass(type(of: self)) + "  " + #function)
        let result = pr_hitTest(point, with: event)
        if result != nil {
            print((NSStringFromClass(type(of: self))) + " pr_hitTesting return:" + NSStringFromClass(type(of: result!)))
        }
        
        return result
    }
    
    @objc public func pr_point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        print(NSStringFromClass(type(of: self)) + " --- pr_pointInside")
        let result = pr_point(inside: point, with: event)
        print(NSStringFromClass(type(of: self)) + " pr_pointInside +++ return: \(result)")
        return result
    }
}
