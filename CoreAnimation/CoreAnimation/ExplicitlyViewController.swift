//
//  ExplicitlyViewController.swift
//  CoreAnimation
//
//  Created by pro648 on 2020/8/9.
//  Copyright © 2020 pro648. All rights reserved.
//
//  详细介绍：[CAAnimation：属性动画CABasicAnimation、CAKeyframeAnimation以及过渡动画、动画组](https://github.com/pro648/tips/blob/master/sources/CAAnimation%EF%BC%9A%E5%B1%9E%E6%80%A7%E5%8A%A8%E7%94%BBCABasicAnimation%E3%80%81CAKeyframeAnimation%E4%BB%A5%E5%8F%8A%E8%BF%87%E6%B8%A1%E5%8A%A8%E7%94%BB%E3%80%81%E5%8A%A8%E7%94%BB%E7%BB%84.md)

import UIKit

class ExplicitlyViewController: BaseViewController {
    
    let layerView = UIView()
    let textField = UITextField()
    let titleLabel = UILabel()
    let balloon = CALayer()
    let transitioningLayer = CATextLayer()
    
    let pushButton = UIButton(type: .system)
    let popButton = UIButton(type: .system)
    
    let infoLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // CABasicAnimation
        layerView.bounds = CGRect(x: 0, y: 0, width: 200, height: 200)
        layerView.backgroundColor = UIColor.blue
        view.addSubview(layerView)
        
        // CATransition
//        transitioningLayer.bounds = CGRect(x: 0, y: 0, width: 320, height: 160)
//        transitioningLayer.backgroundColor = UIColor.red.cgColor
//        transitioningLayer.string = "Red"
//        transitioningLayer.contentsScale = UIScreen.main.scale
//        view.layer.addSublayer(transitioningLayer)
        
//        testNavigationTransition()
        
        // CATransitionDelegate
//        infoLabel.bounds = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 30)
//        infoLabel.textAlignment = .center
//        infoLabel.text = "https://github.com/pro648/tips/tree/master/sources"
//        view.addSubview(infoLabel)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        balloon.contents = UIImage(named: "balloon")!.cgImage
//        view.layer.addSublayer(balloon)
        
        // CASpringAnimation
//        textField.placeholder = "github.com/pro648"
//        textField.borderStyle = .roundedRect
//        view.addSubview(textField)
        
        // UILabel
//        titleLabel.text = "pro648"
//        titleLabel.textAlignment = .center
//        titleLabel.font = UIFont.systemFont(ofSize: 30)
//        view.addSubview(titleLabel)
        
        testAnimationDelegate()
    }
    
    func test() {
        let requestURL = URL(string: "")
        if requestURL?.scheme == "flashbackyard" {
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
//        balloon.removeFromSuperlayer()
        
//        textField.removeFromSuperview()
//        titleLabel.removeFromSuperview()
    }
    
    override func viewWillLayoutSubviews() {
        layerView.center = view.center
        
        textField.frame = CGRect(x: 30, y: 150, width: view.bounds.size.width - 60, height: 30)
        
        titleLabel.bounds = CGRect(x: 0, y: 0, width: 150, height: 50)
        titleLabel.center = CGPoint(x: view.center.x, y: view.center.y - 100)
        
        balloon.frame = CGRect(x: -50, y: 100, width: 50, height: 50)
        
        transitioningLayer.position = view.layer.position
        
        pushButton.center = CGPoint(x: view.bounds.size.width/2 - 100, y: 120)
        popButton.center = CGPoint(x: view.bounds.size.width/2 + 100, y: 120)
        
        infoLabel.center = view.center
    }
    
    override func changeLayerProperty() {
        testBasicAnimation()
//        testSpringAnimation()
//        testKeyframeAnimation()
//        testKeyframeAnimationWithStructValues()
//        testTransition()
//        testAnimationGroup()
        
//        removeAnimatingAnimation()
        
        
        modified = !modified
    }
    
    // MARK: - CABasicAnimation
    
    private func testBasicAnimation() {
//        // 标量
//        let animation = CABasicAnimation(keyPath: "opacity")
//        animation.fromValue = 0
//        animation.toValue = 1
//        layerView.layer.add(animation, forKey: nil)
//        layerView.layer.opacity = 1
        
//        // 非标量
//        let animation = CABasicAnimation(keyPath: "backgroundColor")
//        animation.toValue = UIColor.red.cgColor
//        layerView.layer.add(animation, forKey: nil)
//        layerView.layer.backgroundColor = UIColor.red.cgColor
        
//        // 具有多个值的非标量属性，为fromValue、toValue传入数组。
//        let animation = CABasicAnimation(keyPath: "position")
//        animation.fromValue = [0, 100]
//        animation.toValue = [100, view.bounds.size.height]
//        layerView.layer.add(animation, forKey: nil)
//        layerView.layer.position = CGPoint(x: 100, y: view.bounds.size.height)
        
        // 修改图层的 transform.scale.y
        let animation = CABasicAnimation(keyPath: "transform.scale.y")
        animation.duration = 2
        animation.byValue = 0.5
        animation.toValue = 3
        layerView.layer.add(animation, forKey: nil)
        
        // 1. 使用CATransform3D更新 layer model
        var transform = CATransform3DIdentity
        transform = CATransform3DScale(transform, 1, 3, 1)
        layerView.layer.transform = transform
        
        // 2. 使用 CGAffineTransform 更新 layer model
        layerView.transform = CGAffineTransform(scaleX: 1, y: 3)
    }
    
    private func testSpringAnimation() {
        let jump = CASpringAnimation(keyPath: "position.y")
        jump.initialVelocity = 100.0
        jump.mass = 10.0
        jump.stiffness = 1500.0
        jump.damping = 50.0
        jump.fromValue = textField.layer.position.y + 1.0
        jump.toValue = textField.layer.position.y
        jump.duration = 0.25
        jump.duration = jump.settlingDuration
        textField.layer.add(jump, forKey: nil)
        
        // 红色描边
        textField.layer.borderWidth = 2.0
        textField.layer.borderColor = UIColor.clear.cgColor

        let flash = CASpringAnimation(keyPath: "borderColor")
        flash.damping = 7.0
        flash.stiffness = 200.0
        flash.fromValue = UIColor(red: 1.0, green: 0.27, blue: 0.0, alpha: 1.0).cgColor
        flash.duration = flash.settlingDuration
        textField.layer.add(flash, forKey: nil)

        textField.layer.cornerRadius = 5
    }
    
    // 晃动 titleLabel
    private func testKeyframeAnimation() {
        let wobble = CAKeyframeAnimation(keyPath: "transform.rotation")
        wobble.duration = 0.25
        wobble.repeatCount = 2
        wobble.values = [0.0, -.pi/4.0, 0.0, .pi/4.0, 0.0]
        wobble.keyTimes = [0.0, 0.25, 0.5, 0.75, 1.0]
        titleLabel.layer.add(wobble, forKey: nil)
    }
    
    private func testKeyframeAnimationWithStructValues() {
        let flight = CAKeyframeAnimation(keyPath: "position")
        flight.duration = 3.0
        flight.values = [
            CGPoint(x: -50.0, y: 0.0),
            CGPoint(x: view.bounds.width + 50, y: view.bounds.height / 2.0),
            CGPoint(x: -50.0, y: view.bounds.height - 100)
        ].map({ NSValue(cgPoint: $0) })
        flight.keyTimes = [0.0, 0.5, 1.0]
        balloon.add(flight, forKey: nil)
        balloon.position = CGPoint(x: -50.0, y: view.bounds.height - 100)
    }
    
    // MARK: - CATransition
    private func testTransition() {
        let transition = CATransition()
        transition.duration = 1.5
        transition.type = .push
        transitioningLayer.add(transition, forKey: nil)
        
        // Transition to "blue" state
        transitioningLayer.backgroundColor = UIColor.blue.cgColor
        transitioningLayer.string = "Blue"
    }
    
    private func testNavigationTransition() {
        pushButton.setTitle("Push", for: .normal)
        pushButton.sizeToFit()
        pushButton.addTarget(self, action: #selector(self.handlePushButtonTapped), for: .touchUpInside)
        view.addSubview(pushButton)
        
        popButton.setTitle("Pop", for: .normal)
        popButton.sizeToFit()
        popButton.addTarget(self, action: #selector(self.handlePopButtonTapped), for: .touchUpInside)
        view.addSubview(popButton)
    }
    
    @objc private func handlePushButtonTapped() {
        navigationController?.pushTransition()
        
        let explicitlyVC = ExplicitlyViewController()
        navigationController?.pushViewController(explicitlyVC, animated: false)
    }
    
    @objc private func handlePopButtonTapped() {
        navigationController?.popTransition()
        
        navigationController?.popViewController(animated: false)
    }
    
    // MARK: - CAAnimationGroup
    
    private func testAnimationGroup() {
        let fadeOut = CABasicAnimation(keyPath: "opacity")
        fadeOut.fromValue = 0
        fadeOut.toValue = 1
        
        let expandScale = CABasicAnimation(keyPath: "transform")
        expandScale.valueFunction = CAValueFunction(name: .scale)
        expandScale.fromValue = [1, 1, 1]
        expandScale.toValue = [1.5, 1.5, 1.5]
        
        let rotate = CABasicAnimation(keyPath: "transform")
        rotate.valueFunction = CAValueFunction(name: .rotateZ)
        rotate.fromValue = Float.pi / 4.0
        rotate.toValue = 0.0
        
        let group = CAAnimationGroup()
        group.animations = [fadeOut, expandScale, rotate]
        group.duration = 0.5
        group.beginTime = CACurrentMediaTime() + 0.5
        group.fillMode = .backwards
        group.delegate = self
        
        layerView.layer.add(group, forKey: "group")
    }
    
    // MARK: - CAAnimationDelegate
    
    private func testAnimationDelegate() {
        let flyRight = CABasicAnimation(keyPath: "position.x")
        flyRight.fromValue = -view.bounds.size.width/2
        flyRight.toValue = view.bounds.size.width/2
        flyRight.duration = 2
        flyRight.delegate = self
        flyRight.setValue("form", forKey: "name")
        flyRight.setValue(titleLabel.layer, forKey: "layer")
        titleLabel.layer.add(flyRight, forKey: "title")
        
        flyRight.beginTime = CACurrentMediaTime() + 0.3
        flyRight.fillMode = .both
        flyRight.setValue(textField.layer, forKey: "layer")
        textField.layer.add(flyRight, forKey: "field")
        
        titleLabel.layer.position.x = view.bounds.size.width / 2
        textField.layer.position.x = view.bounds.size.width / 2
    }
    
    private func removeAnimatingAnimation() {
        print(#function)
        
        titleLabel.layer.removeAnimation(forKey: "title")
        textField.layer.removeAnimation(forKey: "field")
    }
}

extension ExplicitlyViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        print(#function)
        
        if !flag {
            print("Did not reached the end of the duration")
            return
        }
        
        guard let name = anim.value(forKey: "name") as? String else { return }
        
        if name == "form" { // form field found
            let layer = anim.value(forKey: "layer") as? CALayer
            anim.setValue(nil, forKey: "layer")
            
            let pulse = CABasicAnimation(keyPath: "transform.scale")
            pulse.fromValue = 1.5
            pulse.toValue = 1.0
            pulse.duration = 0.25
            layer?.add(pulse, forKey: nil)
        }
    }
}
