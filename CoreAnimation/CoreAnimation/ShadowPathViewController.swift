//
//  ShadowPathViewController.swift
//  CoreAnimation
//
//  Created by pro648 on 2020/8/9.
//  Copyright © 2020 pro648. All rights reserved.
//
//  详细介绍：[CoreAnimation基本介绍](https://github.com/pro648/tips/blob/master/sources/CoreAnimation%E5%9F%BA%E6%9C%AC%E4%BB%8B%E7%BB%8D.md)

import UIKit

class ShadowPathViewController: BaseViewController {
    
    let layer = CALayer()
    
    private let width: CGFloat = 150

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        layer.position = view.layer.position
        layer.bounds = CGRect(x: 0, y: 0, width: width * 2, height: width * 2)
        layer.backgroundColor = UIColor.darkGray.cgColor
        view.layer.addSublayer(layer)
    }
    
    @objc override func changeLayerProperty() {
        modified = !modified
//        modifyLayerBounds()
//        modifyLayerPosition()
//        modifyLayerTransform()
        
//        modifyLayerBorder()
//        modifyLayerShadow()
//        modifyLayerShadowPath()
        
//        modifyContents()
        
//        modifyAnchorPointTransform()
    }
    
    /// 修改 bounds
    private func modifyLayerBounds() {
        if modified {
            layer.bounds = CGRect(x: 0, y: 0, width: width * 2, height: width * 2)
        } else {
            layer.bounds = CGRect(x: 0, y: 0, width: width, height: width)
        }
    }
    
    /// 修改 position
    private func modifyLayerPosition() {
        if modified {
            layer.position.y = layer.position.y + width
        } else {
            layer.position.y = layer.position.y - width
        }
    }
    
    /// 修改 transform
    private func modifyLayerTransform() {
        if modified {
            layer.transform = CATransform3DMakeRotation(.pi / 4.0, 0, 0, 1)
        } else {
            layer.transform = CATransform3DIdentity
        }
    }
    
    /// 修改 border
    private func modifyLayerBorder() {
        if modified {
            layer.borderColor = UIColor.orange.cgColor
            layer.borderWidth = 5
            layer.cornerRadius = 15
        } else {
            layer.borderColor = UIColor.black.cgColor
            layer.borderWidth = 0.0
            layer.cornerRadius = 0.0
        }
    }
    
    /// 修改 shadow
    private func modifyLayerShadow() {
        if modified {
            layer.shadowOffset = CGSize(width: 15, height: 20)
            layer.shadowOpacity = 0.5
        } else {
            layer.shadowOffset = CGSize(width: 0, height: -3.0)
            layer.shadowOpacity = 0.0
        }
    }
    
    /// 使用 CGPath 修改shadow
    private func modifyLayerShadowPath() {
        if modified {
            layer.shadowOpacity = 0.8
            
            let shadowHeight: CGFloat = 20
            let shadowPath = CGPath(ellipseIn: CGRect(x: -shadowHeight,
                                                      y: layer.bounds.size.height,
                                                      width: layer.bounds.width + shadowHeight * 2,
                                                      height: shadowHeight),
                                    transform: nil)
            layer.shadowPath = shadowPath
        } else {
            layer.shadowOpacity = 0
        }
    }
    
    /// 修改 contents
    private func modifyContents() {
        if modified {
            layer.contents = UIImage(named: "Ball")?.cgImage
            layer.cornerRadius = 20
            layer.masksToBounds = true
        } else {
            layer.contents = nil
            layer.cornerRadius = 0.0
            layer.masksToBounds = false
        }
    }
    
    /// 修改 anchorPoint 时，position会更新。transform 以 anchorPoint 为中心进行。
    private func modifyAnchorPointTransform() {
        layer.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        layer.bounds = CGRect(x: 0, y: 0, width: width, height: width)
        
        let anchorPoint = CALayer()
        anchorPoint.backgroundColor = UIColor.red.cgColor
        anchorPoint.position = view.layer.position
        anchorPoint.bounds = CGRect(x: 0, y: 0, width: 8, height: 8)
        anchorPoint.cornerRadius = 4
        view.layer.addSublayer(anchorPoint)
        
        if modified {
            layer.transform = CATransform3DMakeRotation(.pi / 4.0, 0, 0, 1)
        } else {
            layer.transform = CATransform3DIdentity
        }
    }
}
