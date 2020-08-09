//
//  LayerTimeViewController.swift
//  CoreAnimation
//
//  Created by pro648 on 2020/8/9.
//  Copyright © 2020 pro648. All rights reserved.
//
//  详细介绍：[图层时间CAMediaTiming](https://github.com/pro648/tips/blob/master/sources/%E5%9B%BE%E5%B1%82%E6%97%B6%E9%97%B4CAMediaTiming.md)

import UIKit

class LayerTimeViewController: BaseViewController {
    
    let doorLayer = CALayer()
    
    @IBOutlet weak var timeOffsetSlide: UISlider!
    @IBOutlet weak var speedSlide: UISlider!
    @IBOutlet weak var timeOffsetLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    let bezierPath = UIBezierPath()
    let shipLayer = CALayer()
    @IBOutlet weak var shipControl: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        shipControl.isHidden = true
//        swingingDoorUsingAutoreverse()
        
        createShip()
    }
    
    override func viewDidLayoutSubviews() {
        doorLayer.position = CGPoint(x: view.bounds.size.width / 2 - 64, y: view.bounds.size.height / 2)
    }
    
    override func changeLayerProperty() {
        
    }
    
    private func swingingDoorUsingAutoreverse() {
        doorLayer.bounds = CGRect(x: 0, y: 0, width: 128, height: 256)
        // 设置锚点为layer左边缘中点
        doorLayer.anchorPoint = CGPoint(x: 0, y: 0.5)
        doorLayer.contents = UIImage(named: "Door")?.cgImage
        view.layer.addSublayer(doorLayer)
        
        // Apply perspective transform
        var perspective = CATransform3DIdentity
        perspective.m34 = -1.0 / 500.0
        view.layer.sublayerTransform = perspective
        
        // Apply swinging animation
        let animation = CABasicAnimation(keyPath: "transform.rotation.y")
        animation.toValue = -.pi/2.0
        animation.duration = 2.0
        animation.repeatDuration = .infinity
        animation.autoreverses = true
        doorLayer.add(animation, forKey: nil)
    }
    
    // MARK: Relative Time
    
    private func createShip() {
        shipControl.isHidden = false
        
        // Create a path
        let centerX = view.bounds.size.width / 2
        let centerY = view.bounds.size.height / 2

        bezierPath.move(to: CGPoint(x: view.bounds.size.width / 2 - 150, y: centerY))
        bezierPath.addCurve(to: CGPoint(x: centerX + 150, y: centerY), controlPoint1: CGPoint(x: centerX - 75, y: centerY - 150), controlPoint2: CGPoint(x: centerX + 75, y: centerY + 150))
        
        // Draw the path using a CAShapeLayer
        let pathLayer = CAShapeLayer()
        pathLayer.path = bezierPath.cgPath
        pathLayer.fillColor = UIColor.clear.cgColor
        pathLayer.strokeColor = UIColor.red.cgColor
        pathLayer.lineWidth = 3.0
        view.layer.addSublayer(pathLayer)
        
        // Add the ship
        shipLayer.bounds = CGRect(x: 0, y: 0, width: 64, height: 64)
        shipLayer.position = CGPoint(x: centerX - 150, y: centerY)
        shipLayer.contents = UIImage(named: "Ship")?.cgImage
        view.layer.addSublayer(shipLayer)
        
        updateSliders()
    }
    
    @IBAction func updateSliders() {
        let timeOffset = timeOffsetSlide.value
        timeOffsetLabel.text = String(format: "%.2f", timeOffset)
        
        let speed = speedSlide.value
        speedLabel.text = String(format: "%.2f", speed)
    }
    
    @IBAction func playButtonTapped(_ sender: Any) {
        // Create the keyframe animation
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.timeOffset = CFTimeInterval(timeOffsetSlide.value)
        animation.speed = speedSlide.value
        animation.duration = 1.0
        animation.path = bezierPath.cgPath
        animation.rotationMode = .rotateAuto
        animation.isRemovedOnCompletion = true
        shipLayer.add(animation, forKey: nil)
    }
}
