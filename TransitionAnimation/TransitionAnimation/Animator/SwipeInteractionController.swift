//
//  SwipeInteractionController.swift
//  TransitionAnimation
//
//  Created by pro648 on 2020/8/28.
//  Copyright © 2020 pro648. All rights reserved.
//

import UIKit

class SwipeInteractionController: UIPercentDrivenInteractiveTransition {
    
    var interactionInProgress = false
    private var shouldCompleteTransition = false
    
    /// 交互手势发生的视图控制器
    private weak var viewController: UIViewController!
    
    init(viewController: UIViewController) {
        super.init()
        self.viewController = viewController
        
        prepareGestureRecognizer(in: viewController.view)
    }
    
    private func prepareGestureRecognizer(in view: UIView) {
        let gestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(self.handleGesture(_:)))
        gestureRecognizer.edges = .left
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func handleGesture(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        // 使用局部变量计算滑动进度
        let translation = gestureRecognizer.translation(in: gestureRecognizer.view?.superview)
        guard let gestureView = gestureRecognizer.view else { return }
        let percent = translation.x / gestureView.bounds.size.width
        
        switch gestureRecognizer.state {
        case .began:
            // 手势开始时标记为动画进行中，并调用dismiss(animated:completion:)
            interactionInProgress = true
            viewController.dismiss(animated: true, completion: nil)
            
        case .changed:
            // 更新动画进度
            update(percent)
            
        case .cancelled:
            // 如果动画取消，更新interactionInProgress，并回滚动画。
            cancel()
            interactionInProgress = false
            
        case .ended:
            // 手势结束时，根据当前进度、速度决定结束还是取消动画。
            interactionInProgress = false
            let velocity = gestureRecognizer.velocity(in: gestureView)
            if percent > 0.5 || velocity.x > 0 {
                finish()
            } else {
                cancel()
            }
            
        default:
            break
        }
    }
}
