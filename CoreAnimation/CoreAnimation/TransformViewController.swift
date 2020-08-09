//
//  TransformViewController.swift
//  CoreAnimation
//
//  Created by pro648 on 2020/8/9.
//  Copyright © 2020 pro648. All rights reserved.
//
//  详细介绍：[CGAffineTransform和CATransform3D](https://github.com/pro648/tips/blob/master/sources/CGAffineTransform%E5%92%8CCATransform3D.md)

import UIKit

class TransformViewController: BaseViewController {
    
    let imgLayer = CALayer()
    let imgLayer2 = CALayer()
    
    let outerLayer = CALayer()
    let innerLayer = CALayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        imgLayer.position = view.layer.position
        imgLayer.bounds = CGRect(x: 0, y: 0, width: 200, height: 200)
        imgLayer.contents = UIImage(named: "Snowman")?.cgImage
        imgLayer.backgroundColor = UIColor.lightGray.cgColor
        
        view.layer.addSublayer(imgLayer)

//        addImgLayer2()
        
//        outerLayer.position = view.layer.position
//        outerLayer.bounds = CGRect(x: 0, y: 0, width: 200, height: 200)
//        outerLayer.backgroundColor = UIColor.lightGray.cgColor
//        view.layer.addSublayer(outerLayer)
//
//        innerLayer.position = CGPoint(x: outerLayer.bounds.size.width / 2.0, y: outerLayer.bounds.size.height / 2.0)
//        innerLayer.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
//        innerLayer.backgroundColor = UIColor.darkGray.cgColor
//        outerLayer.addSublayer(innerLayer)
    }
    
    @objc override func changeLayerProperty() {
//        testCGAffine()
        testCompoundTransform()
//        testShearTransform()
//        test3DRotate()
//        testPerspectiveProjection()
        
//        testSublayerTransform()
        
//        testOppositeRotationTransform()
        
        modified = !modified
    }
    
    /// 旋转 layer
    private func testCGAffine() {
        if modified {
            imgLayer.setAffineTransform(CGAffineTransform(rotationAngle: -1))
        } else {
            imgLayer.setAffineTransform(CGAffineTransform(rotationAngle: 1))
        }
    }
    
    // 拼接矩阵
    private func testCompoundTransform() {
        if modified {
            imgLayer.setAffineTransform(CGAffineTransform.identity)
        } else {
            var transform = CGAffineTransform.identity
            // 先旋转，后平移。
            transform = transform.rotated(by: .pi / 4)
            transform = transform.translatedBy(x: 100, y: 0)
            
            // 先平移，后旋转。
//            transform = transform.translatedBy(x: 100, y: 0)
//            transform = transform.rotated(by: .pi / 4)
            
            imgLayer.setAffineTransform(transform)
        }
        
    }
    
    /// 剪切变换
    private func testShearTransform() {
        if modified {
            imgLayer.setAffineTransform(CGAffineTransform.identity)
        } else {
            imgLayer.setAffineTransform(makeShear(with: 1, y: 0))
        }
    }
    
    private func makeShear(with x:CGFloat, y: CGFloat) -> CGAffineTransform {
        var transform = CGAffineTransform.identity
        transform.c = -x
        transform.b = -y
        return transform
    }
    
    /// 绕y轴旋转
    private func test3DRotate() {
        if modified {
            imgLayer.transform = CATransform3DIdentity
        } else {
            imgLayer.transform = CATransform3DMakeRotation(.pi / 4.0, 0, 1, 0)
        }
    }
    
    /// 透视投影
    private func testPerspectiveProjection() {
        if modified {
            imgLayer.transform = CATransform3DIdentity
        } else {
            var transform = CATransform3DIdentity
            transform.m34 = -1.0 / 500.0
            transform = CATransform3DRotate(transform, .pi / 4.0, 0, 1, 0)
            
            imgLayer.transform = transform
        }
    }
    
    /// 添加右侧图片，更新左侧图片 position
    private func addImgLayer2() {
        imgLayer.position = CGPoint(x: view.layer.position.x - 120, y: view.layer.position.y)
        
        imgLayer2.position = CGPoint(x: view.layer.position.x + 120, y: view.layer.position.y)
        imgLayer2.bounds = CGRect(x: 0, y: 0, width: 200, height: 200)
        imgLayer2.contents = UIImage(named: "Snowman")?.cgImage
        imgLayer2.backgroundColor = UIColor.lightGray.cgColor
        view.layer.addSublayer(imgLayer2)
    }
    
    /// sublayerTransform 设置
    private func testSublayerTransform() {
        var perspective = CATransform3DIdentity
        perspective.m34 = -1.0 / 500.0
        view.layer.sublayerTransform = perspective
        
        if modified {
            imgLayer.transform = CATransform3DIdentity
            imgLayer2.transform = CATransform3DIdentity
        } else {
            let transform1 = CATransform3DMakeRotation(.pi/4.0, 0, 1, 0)
            imgLayer.transform = transform1
            
            let transform2 = CATransform3DMakeRotation(-.pi/4.0, 0, 1, 0)
            imgLayer2.transform = transform2
        }
    }
    
    private func testOppositeRotationTransform() {
        if modified {
            outerLayer.transform = CATransform3DIdentity
            innerLayer.transform = CATransform3DIdentity
        } else {
            outerLayer.transform = CATransform3DMakeRotation(.pi/4, 0, 0, 1)
            innerLayer.transform = CATransform3DMakeRotation(-.pi/4, 0, 0, 1)
        }
    }
}
