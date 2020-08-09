//
//  ScrollView.swift
//  CoreAnimation
//
//  Created by pro648 on 2020/8/9.
//  Copyright © 2020 pro648. All rights reserved.
//
//  详细介绍：[CALayer及其各种子类](https://github.com/pro648/tips/blob/master/sources/CALayer%E5%8F%8A%E5%85%B6%E5%90%84%E7%A7%8D%E5%AD%90%E7%B1%BB.md)

import UIKit

class ScrollView: UIView {
    
    override class var layerClass: AnyClass {
        return CAScrollLayer.self
    }
    
    private func setup() {
        // Enable clipping
        layer.masksToBounds = true
        backgroundColor = UIColor.lightGray
        
        // Attach pan gesture recognizer
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(self.pan(_:)))
        addGestureRecognizer(recognizer)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    @objc func pan(_ recognizer: UIPanGestureRecognizer) {
        // Get the offset by subtracting the pan gesture
        // Transform from the current bounds origin
        var offset = self.bounds.origin
        offset.x -= recognizer.translation(in: self).x
        offset.y -= recognizer.translation(in: self).y
        
        // Scroll the layer
        layer.scroll(offset)
        
        // Reset the pan gesture translation
        recognizer.setTranslation(CGPoint.zero, in: self)
    }
}
