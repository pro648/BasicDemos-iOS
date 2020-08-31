//
//  PresentAnimationController.swift
//  TransitionAnimation
//
//  Created by pro648 on 2020/8/28.
//  Copyright © 2020 pro648. All rights reserved.
//

import UIKit

class PresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    /// 动画时长
    private let duration: TimeInterval = 1.5
    private let originFrame: CGRect
    
    init(originFrame: CGRect) {
        self.originFrame = originFrame
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // 获取被替换的和即将显示的视图控制器，以及转场后视图快照。
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to),
            let snapshot = toVC.view.snapshotView(afterScreenUpdates: true) else { return }
        
        // 所有动画发生于 containerView 上，获取 containerView 和最终视图大小。
        let containerView = transitionContext.containerView
        let finalFrame = transitionContext.finalFrame(for: toVC)
        
        // 配置 snapshot frame和其它属性，以刚好覆盖在 card 上。
        snapshot.frame = originFrame
        snapshot.layer.cornerRadius = CardViewController.cardCornerRadius
        snapshot.layer.masksToBounds = true
        
        // containerView 只包含 fromVC 的view，添加toView和snapshot。
        containerView.addSubview(toVC.view)
        containerView.addSubview(snapshot)
        toVC.view.isHidden = true
        
        AnimationHelper.perspectiveTransform(for: containerView)
        snapshot.layer.transform = AnimationHelper.yRotation(.pi/2)
        
        // UIView动画时长必须与转场动画时长一致。
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModeCubic, animations: {
            // 绕y轴旋转 fromView 90度，以隐藏 fromView
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1/3) {
                fromVC.view.layer.transform = AnimationHelper.yRotation(-.pi/2)
            }
            
            // 再次旋转 snapshot，以显示它。
            UIView.addKeyframe(withRelativeStartTime: 1/3, relativeDuration: 1/3) {
                snapshot.layer.transform = AnimationHelper.yRotation(0.0)
            }
            
            // 放大 snapshot 至全屏。
            UIView.addKeyframe(withRelativeStartTime: 2/3, relativeDuration: 1/3) {
                snapshot.frame = finalFrame
                snapshot.layer.cornerRadius = 0
            }
        }) { (_) in
            // snapshot已经是全屏，隐藏snapshot显示出 toView。
            toVC.view.isHidden = false
            snapshot.removeFromSuperview()
            fromVC.view.layer.transform = CATransform3DIdentity
            
            // 调用completeTransition(_:)告诉系统动画已经结束。
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
}
