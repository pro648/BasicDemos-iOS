//
//  AnimationHelper.swift
//  TransitionAnimation
//
//  Created by pro648 on 2020/8/25.
//  Copyright © 2020 pro648. All rights reserved.
//

import UIKit

struct AnimationHelper {
    static func yRotation(_ angle: Double) -> CATransform3D {
        return CATransform3DMakeRotation(CGFloat(angle), 0.0, 1.0, 0.0)
    }
    
    static func perspectiveTransform(for containerView: UIView) {
        var transform = CATransform3DIdentity
        transform.m34 = -1 / 500
        containerView.layer.sublayerTransform = transform
    }
}
