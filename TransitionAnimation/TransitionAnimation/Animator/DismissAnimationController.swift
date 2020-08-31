//
//  DismissAnimationController.swift
//  TransitionAnimation
//
//  Created by pro648 on 2020/8/28.
//  Copyright © 2020 pro648. All rights reserved.
//

import UIKit

class DismissAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    /// 转场结束时动画终点
    private let destinationFrame: CGRect
    private let duration: TimeInterval = 0.6
    let interactionController: SwipeInteractionController?
    
    // 交互式
    init(destinationFrame: CGRect, interactionController: SwipeInteractionController?) {
        self.destinationFrame = destinationFrame
        self.interactionController = interactionController
    }
    
    // 没有交互式
//    init(destinationFrame: CGRect) {
//        self.destinationFrame = destinationFrame
//    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // 这次需要操控 fromView
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to),
            let snapshot = fromVC.view.snapshotView(afterScreenUpdates: false) else { return }
        
        snapshot.layer.cornerRadius = CardViewController.cardCornerRadius
        snapshot.layer.masksToBounds = true
        
        // 视图层级需是：toView、fromView、snapshot
        let containerView = transitionContext.containerView
        containerView.insertSubview(toVC.view, at: 0)
        containerView.addSubview(snapshot)
        fromVC.view.isHidden = true
        
        // 先旋转 toView，以便动画开始时不立即显示 toView。
        AnimationHelper.perspectiveTransform(for: containerView)
        toVC.view.layer.transform = AnimationHelper.yRotation(-.pi/2)
        
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModeCubic, animations: { // 动画顺序与 present 相反
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1/3) {
                snapshot.frame = self.destinationFrame
            }
            
            UIView.addKeyframe(withRelativeStartTime: 1/3, relativeDuration: 1/3) {
                snapshot.layer.transform = AnimationHelper.yRotation(.pi/2)
            }
            
            UIView.addKeyframe(withRelativeStartTime: 2/3, relativeDuration: 1/3) {
                toVC.view.layer.transform = AnimationHelper.yRotation(0.0)
            }
        }) { (_) in
            // completeTransition(_:)前，移除所有对视图层级的修改。
            fromVC.view.isHidden = false
            snapshot.removeFromSuperview()
            if transitionContext.transitionWasCancelled {
                toVC.view.removeFromSuperview()
            }
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
