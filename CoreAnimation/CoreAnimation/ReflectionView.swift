//
//  ReflectionView.swift
//  CoreAnimation
//
//  Created by pro648 on 2020/8/9.
//  Copyright © 2020 pro648. All rights reserved.
//
//  详细介绍：[CALayer及其各种子类](https://github.com/pro648/tips/blob/master/sources/CALayer%E5%8F%8A%E5%85%B6%E5%90%84%E7%A7%8D%E5%AD%90%E7%B1%BB.md)

import UIKit

/// 使用 CAReplicatorLayer，添加一个负比例变换到复制图层，就可以创建指定视图的镜像图片，这样就创建了一个实时「反射」效果。
/// ReflectionView 完成了一个自适应渐变淡出效果（使用CAGradientLayer 和 mask 实现）https://github.com/nicklockwood/ReflectionView
class ReflectionView: UIView {
    
    override class var layerClass: AnyClass {
        return CAReplicatorLayer.self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        let layer = self.layer as! CAReplicatorLayer
        layer.instanceCount = 2
        
        // Move reflection instance below original and flip vertically
        var transform = CATransform3DIdentity
        let verticalOffset = self.bounds.size.height + 2
        transform = CATransform3DTranslate(transform, 0, verticalOffset, 0)
        transform = CATransform3DScale(transform, 1, -1, 0)
        layer.instanceTransform = transform
        
        // Reduce alpha of reflection layer
        layer.instanceAlphaOffset = -0.6
    }
}
