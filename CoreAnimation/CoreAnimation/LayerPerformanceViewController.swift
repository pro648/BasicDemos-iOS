//
//  LayerPerformanceViewController.swift
//  CoreAnimation
//
//  Created by pro648 on 2020/8/9.
//  Copyright © 2020 pro648. All rights reserved.
//
//  详细介绍：[图层性能之离屏渲染、栅格化、回收池](https://github.com/pro648/tips/blob/master/sources/%E5%9B%BE%E5%B1%82%E6%80%A7%E8%83%BD%E4%B9%8B%E7%A6%BB%E5%B1%8F%E6%B8%B2%E6%9F%93%E3%80%81%E6%A0%85%E6%A0%BC%E5%8C%96%E3%80%81%E5%9B%9E%E6%94%B6%E6%B1%A0.md)

import UIKit

class LayerPerformanceViewController: BaseViewController {
    
    let blueLayer = CAShapeLayer()
    
    let width = 100
    let height = 100
    let depth = 10
    let size: CGFloat = 100.0
    let spacing: CGFloat = 150.0
    let cameraDistance: CGFloat = 500.0
    
    var scrollView = UIScrollView()
    var recyclePool = NSMutableSet()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        testShapeLayer()
//        testStretchImage()
        testGroupOpacity()
//        test3DMatrixLayer()
        
    }
    
    override func viewWillLayoutSubviews() {
        blueLayer.position = view.layer.position
        
//        updateLayers()
    }
    
    override func changeLayerProperty() {
        
    }
    
    private func testShapeLayer() {
        blueLayer.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
        blueLayer.fillColor = UIColor.blue.cgColor
        blueLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 100, height: 100), byRoundingCorners: [.topLeft, .bottomRight], cornerRadii: CGSize(width: 10, height: 10)).cgPath
        view.layer.addSublayer(blueLayer)
    }
    
    private func testStretchImage() {
        blueLayer.bounds = CGRect(x: 0, y: 0, width: 200, height: 200)
        blueLayer.contentsCenter = CGRect(x: 0.5, y: 0.5, width: 0.0, height: 0.0)
        blueLayer.contentsScale = UIScreen.main.scale
        blueLayer.contents = UIImage(named: "Rounded")?.cgImage
        view.layer.addSublayer(blueLayer)
    }
    
    private func testGroupOpacity() {
        let redLayer1 = CALayer()
        redLayer1.frame = CGRect(x: view.bounds.size.width / 2 - 130, y: 100, width: 100, height: 200)
        redLayer1.backgroundColor = UIColor.red.cgColor
        redLayer1.opacity = 0.5
        redLayer1.allowsGroupOpacity = true
        view.layer.addSublayer(redLayer1)
        
        let blueLayer1 = CALayer()
        blueLayer1.frame = CGRect(x: 0, y: 0, width: 50, height: 100)
        blueLayer1.backgroundColor = UIColor.blue.cgColor
        blueLayer1.opacity = 0.8
        redLayer1.addSublayer(blueLayer1)
        
        // 关闭 group opacity
        let redLayer2 = CALayer()
        redLayer2.frame = CGRect(x: view.bounds.size.width / 2 + 30, y: 100, width: 100, height: 200)
        redLayer2.backgroundColor = UIColor.red.cgColor
        redLayer2.opacity = 0.5
        redLayer2.allowsGroupOpacity = false
        view.layer.addSublayer(redLayer2)
        
        let blueLayer2 = CALayer()
        blueLayer2.frame = CGRect(x: 0, y: 0, width: 50, height: 100)
        blueLayer2.backgroundColor = UIColor.blue.cgColor
        blueLayer2.opacity = 0.8
        redLayer2.addSublayer(blueLayer2)
    }
    
    // 创建3D图层矩阵
    private func test3DMatrixLayer() {
        scrollView.frame = view.bounds
        scrollView.backgroundColor = .gray
        scrollView.contentSize = CGSize(width: spacing * CGFloat(width - 1), height: CGFloat(height - 1) * spacing)
        scrollView.delegate = self
        view.addSubview(scrollView)
        
        var transform = CATransform3DIdentity
        transform.m34 = -1.0 / cameraDistance
        scrollView.layer.sublayerTransform = transform
        
//        create3DMatrixLayer()
    }
    
    private func create3DMatrixLayer() {
        // Create layers
        for z in 0...(depth-1) {
            for y in 0...height {
                for x in 0...width {
                    // Create layer
                    let layer = CALayer()
                    layer.frame = CGRect(x: 0, y: 0, width: size, height: size)
                    layer.position = CGPoint(x: CGFloat(x) * spacing, y: CGFloat(y) * spacing)
                    layer.zPosition = -CGFloat(z) * spacing
                    
                    // Set background color
                    layer.backgroundColor = UIColor(white: 1-CGFloat(z)*(1.0/CGFloat(depth)), alpha: 1.0).cgColor
                    
                    // Attach to scroll view
                    scrollView.layer.addSublayer(layer)
                }
            }
        }
        
        print("Displayed:\(depth * height * width)")
    }
    
    // MARK: - 循环使用已创建的图层
    
    private func perspective(_ z: CGFloat) -> CGFloat {
        return cameraDistance / (z + cameraDistance)
    }
    
    func updateLayers() {
        // Calculate clipping bounds
        var bounds = scrollView.bounds
        bounds.origin = scrollView.contentOffset
        bounds = bounds.insetBy(dx: -size/2, dy: -size/2)
        
        // Add existing layers to pool
        recyclePool.addObjects(from: scrollView.layer.sublayers ?? [])
        
        // Disable animation
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        // Create layers
        var recycled = 0
        var visibleLayers = [CALayer]()
        for z in (0...(depth-1)).reversed() {
            // Increase bounds size to compensate for perspective
            var adjusted = bounds
            adjusted.size.width /= perspective(CGFloat(z)*spacing)
            adjusted.size.height /= perspective(CGFloat(z)*spacing)
            adjusted.origin.x -= (adjusted.size.height - bounds.size.width) / 2
            adjusted.origin.y -= (adjusted.size.height - bounds.size.height) / 2
            
            for y in 0...height {
                // Check if vertically outside visible rect
                
                if CGFloat(y) * spacing < adjusted.origin.y || CGFloat(y)*spacing >= adjusted.origin.y + adjusted.size.height {
                    continue
                }
                
                for x in 0...width {
                    // Check if horizontally outside visible rect
                    if CGFloat(x)*spacing < adjusted.origin.x || CGFloat(x) * spacing >= adjusted.origin.x + adjusted.size.width {
                        continue
                    }
                    
                    // Recycle layer if available
                    var layer = recyclePool.anyObject() as? CALayer
                    if layer != nil {
                        recycled += 1
                        recyclePool.remove(layer)
                    } else {
                        // Otherwise create a new one
                        layer = CALayer()
                        layer?.frame = CGRect(x: 0, y: 0, width: size, height: size)
                    }
                    
                    // Set position
                    layer?.position = CGPoint(x: CGFloat(x)*spacing, y: CGFloat(y)*spacing)
                    layer?.zPosition = -CGFloat(z)*spacing
                    
                    // Set background color
                    layer?.backgroundColor = UIColor(white: 1-CGFloat(z)*(1.0/CGFloat(depth)), alpha: 1).cgColor
                    
                    // Attach to scroll view
                    visibleLayers.append(layer!)
                }
            }
        }
        
        // Update layers
        scrollView.layer.sublayers = visibleLayers
        
        print("Displayed:\(visibleLayers.count)/\(depth*height*width)")
    }
}

extension LayerPerformanceViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateLayers()
    }
}
