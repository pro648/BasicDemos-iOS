//
//  LayersViewController.swift
//  CoreAnimation
//
//  Created by pro648 on 2020/8/9.
//  Copyright © 2020 pro648. All rights reserved.
//
// 详细介绍：[CALayer及其各种子类](https://github.com/pro648/tips/blob/master/sources/CALayer%E5%8F%8A%E5%85%B6%E5%90%84%E7%A7%8D%E5%AD%90%E7%B1%BB.md)

import UIKit

class LayersViewController: BaseViewController {
    
    var shapeLayer = CAShapeLayer()
    let textLayer = CATextLayer()
    var cube1: CALayer?
    var cube2: CALayer?
    var gradient = CAGradientLayer()
    var replicatorLayer = CAReplicatorLayer()
    
    // CATiledLayer
    var scrollView = UIScrollView()
    
    /// 粒子图层
    let emitter = CAEmitterLayer()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        testLineDashPhase()
//        testMask()
//        testTextLayer()
        
//        testTransformLayerA()
//        testTransformLayerB()
//        testGradientLayer()
//        testReplicatorLayer()
//        testTiledLayer()
        testEmitterLayer()
    }
    
    override func viewDidLayoutSubviews() {
        textLayer.position = view.layer.position
        textLayer.bounds = CGRect(x: 0, y: 0, width: view.bounds.size.width / 2, height: view.bounds.size.height / 2)
        
        cube1?.position = view.layer.position
        cube2?.position = view.layer.position
        
        gradient.position = view.layer.position
        
        replicatorLayer.position = view.layer.position
        
        scrollView.center = view.center
        scrollView.bounds = view.bounds
        
        emitter.position = view.layer.position
        emitter.bounds = view.bounds
    }
    
    override func changeLayerProperty() {
        
        modified = !modified
    }
    
    // MARK: - CAShapeLayer
    
    /// CAShapeLayer
    private func testLineDashPhase() {
        // Create path
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 175, y: 100))
        path.addArc(withCenter: CGPoint(x: 150, y: 100), radius: 25, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        path.move(to: CGPoint(x: 150, y: 125))
        path.addLine(to: CGPoint(x: 150, y: 175))
        path.addLine(to: CGPoint(x: 125, y: 225))
        path.move(to: CGPoint(x: 150, y: 175))
        path.addLine(to: CGPoint(x: 175, y: 225))
        path.move(to: CGPoint(x: 100, y: 150))
        path.addLine(to: CGPoint(x: 200, y: 150))
        
        // Create shape layer
        let shapelLayer = CAShapeLayer()
        shapelLayer.strokeColor = UIColor.red.cgColor
        shapelLayer.fillColor = UIColor.clear.cgColor
        shapelLayer.lineWidth = 5
        shapelLayer.lineJoin = .bevel
        shapelLayer.lineCap = .round
        shapelLayer.path = path.cgPath
        
        // Add it to our view
        view.layer.addSublayer(shapelLayer)
    }
    
    /// 只有 parent layer 与 mask 相交部分可见，其他区域都会被隐藏。
    private func testMask() {
        // Create path
        let rect = CGRect(x: 0, y: 0, width: 100, height: 100)
        let radii = CGSize(width: 20, height: 20)
        let path = UIBezierPath.init(roundedRect: rect, byRoundingCorners: [.topRight, .bottomRight, .bottomLeft], cornerRadii: radii)
        
        let layer = CALayer()
        layer.backgroundColor = UIColor.gray.cgColor
        layer.position = view.center
        layer.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
        
        // Create mask layer
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        layer.mask = maskLayer
        
        view.layer.addSublayer(layer)
    }
    
    // MARK: - CATextLayer
    
    /// CATextLayer
    private func testTextLayer() {
        textLayer.backgroundColor = UIColor.gray.cgColor
        textLayer.contentsScale = UIScreen.main.scale
        view.layer.addSublayer(textLayer)
        
        textLayer.alignmentMode = .justified
        textLayer.isWrapped = true
        
        let text = """
                Lorem ipsum dolor sit amet, consectetur adipiscing
                elit. Quisque massa arcu, eleifend vel varius in, facilisis pulvinar
                leo. Nunc quis nunc at mauris pharetra condimentum ut ac neque. Nunc
                elementum, libero ut porttitor dictum, diam odio congue lacus, vel
                fringilla sapien diam at purus. Etiam suscipit pretium nunc sit amet
                lobortis
                """
        let attributedString = NSMutableAttributedString(string: text)
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.red, .kern: 10]
        attributedString.addAttributes(attributes, range: NSMakeRange(6, 5))
        textLayer.string = attributedString
    }
    
    // MARK: - CATransformLayer
    
    /// 四个 layer，x、y坐标相同，z坐标不同。
    private func testTransformLayerA() {
        // Create the container as a CATransformLayer
        let container = CATransformLayer()
        
        // 如果使用CALayer，不能得到三维图层。
//        let container = CALayer()
        container.frame = view.frame
        view.layer.addSublayer(container)
        
        // Planes data
        let planesPosition = view.layer.position
        let planeSize = CGSize(width: 100, height: 100)
        
        // Create 4 planes
        let purplePlane = addPlane(to: container, size: planeSize, position: planesPosition, color: UIColor.purple)
        let redPlane = addPlane(to: container, size: planeSize, position: planesPosition, color: UIColor.red)
        let orangePlane = addPlane(to: container, size: planeSize, position: planesPosition, color: UIColor.orange)
        let yellowPlane = addPlane(to: container, size: planeSize, position: planesPosition, color: UIColor.yellow)
        
        // Apply transform to the container
        var t = CATransform3DIdentity
        t.m34 = 1.0 / -500
        t = CATransform3DRotate(t, .pi/3, 0, 1, 0)
        container.transform = t
        
        // Apply transform to the planes
        t = CATransform3DIdentity
        t = CATransform3DTranslate(t, 0, 0, 0)
        purplePlane.transform = t
        
        // Apply transform to the planes
        t = CATransform3DIdentity
        t = CATransform3DTranslate(t, 0, 0, -40)
        redPlane.transform = t
        
        // Apply transform to the planes
        t = CATransform3DIdentity
        t = CATransform3DTranslate(t, 0, 0, -80)
        orangePlane.transform = t
        
        // Apply transform to the planes
        t = CATransform3DIdentity
        t = CATransform3DTranslate(t, 0, 0, -120)
        yellowPlane.transform = t
    }
    
    private func addPlane(to container: CALayer, size: CGSize, position: CGPoint, color: UIColor) -> CALayer {
        let plane = CALayer()
        plane.backgroundColor = color.cgColor
        plane.opacity = 0.6
        plane.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        plane.position = position
        plane.borderColor = UIColor.init(white: 1.0, alpha: 0.5).cgColor
        plane.borderWidth = 3
        plane.cornerRadius = 10
        container.addSublayer(plane)
        
        return plane
    }
    
    /// 立方体效果
    private func testTransformLayerB() {
        // Setup the perspective transform
        var pt = CATransform3DIdentity
        pt.m34 = -1.0/500.0
        view.layer.sublayerTransform = pt
        
        // Set up the transform for cube 1 and add it
        var clt = CATransform3DIdentity
        clt = CATransform3DTranslate(clt, -100, 0, 0)
        cube1 = cubeWithTransform(clt)
        guard let cube1 = cube1 else { return }
        view.layer.addSublayer(cube1)
        
        // Set up the transform for cube 2 and add it
        var c2t = CATransform3DIdentity
        c2t = CATransform3DTranslate(c2t, 100, 0, 0)
        c2t = CATransform3DRotate(c2t, -.pi/4, 1, 0, 0)
        c2t = CATransform3DRotate(c2t, -.pi/4, 0, 1, 0)
        cube2 = cubeWithTransform(c2t)
        guard let cube2 = cube2 else { return }
        view.layer.addSublayer(cube2)
    }
    
    private func faceWithTransform(_ transform: CATransform3D) -> CALayer {
        // Create cube face layer
        let face = CALayer()
        face.frame = CGRect(x: -50, y: -50, width: 100, height: 100)
        
        // Apply a random color
        face.backgroundColor = UIColor.random().cgColor
        
        // Apply the transform and return
        face.transform = transform
        return face
    }
    
    private func cubeWithTransform(_ transform: CATransform3D) -> CALayer {
        // Create cube layer
        let cube = CATransformLayer()
        
        // Add cube face 1
        var ct = CATransform3DMakeTranslation(0, 0, 50)
        cube.addSublayer(faceWithTransform(ct))
        
        // Add cube face 2
        ct = CATransform3DMakeTranslation(50, 0, 0)
        ct = CATransform3DRotate(ct, .pi / 2, 0, 1, 0)
        cube.addSublayer(faceWithTransform(ct))

        // Add cube face 3
        ct = CATransform3DMakeTranslation(0, -50, 0)
        ct = CATransform3DRotate(ct, .pi / 2, 1, 0, 0)
        cube.addSublayer(faceWithTransform(ct))

        // Add cube face 4
        ct = CATransform3DMakeTranslation(0, 50, 0)
        ct = CATransform3DRotate(ct, -.pi / 2, 1, 0, 0)
        cube.addSublayer(faceWithTransform(ct))

        // Add cube face 5
        ct = CATransform3DMakeTranslation(-50, 0, 0)
        ct = CATransform3DRotate(ct, -.pi/2, 0, 1, 0)
        cube.addSublayer(faceWithTransform(ct))

        // Add cube face 6
        ct = CATransform3DMakeTranslation(0, 0, -50)
        ct = CATransform3DRotate(ct, .pi, 0, 1, 0)
        cube.addSublayer(faceWithTransform(ct))
        
        // Center the cube layer within the container
        cube.position = view.layer.position
        
        // Apply the transform and return
        cube.transform = transform
        return cube
    }
    
    // MARK: - CAGradientLayer
    
    /// CAGradientLayer
    private func testGradientLayer() {
        gradient.bounds = CGRect(x: 0, y: 0, width: 200, height: 200)
        
        // Version 1
//        gradient.colors = [UIColor.red.cgColor, UIColor.blue.cgColor]
        
        // Version 2
        gradient.colors = [UIColor.red.cgColor, UIColor.yellow.cgColor, UIColor.green.cgColor]
        gradient.locations = [0.0, 0.25, 0.5]
        
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        
        view.layer.addSublayer(gradient)
    }
    
    // MARK: - CAReplicatorLayer
    
    private func testReplicatorLayer() {
        view.backgroundColor = UIColor.lightGray
        
        replicatorLayer.bounds = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height)
        view.layer.addSublayer(replicatorLayer)
        
        // Configure the replicator
        replicatorLayer.instanceCount = 10
        
        // Apply a transform for each instance
        var transform = CATransform3DIdentity
        transform = CATransform3DTranslate(transform, 0, 200, 0)
        transform = CATransform3DRotate(transform, .pi / 5.0, 0, 0, 1)
        transform = CATransform3DTranslate(transform, 0, -200, 0)
        replicatorLayer.instanceTransform = transform
        
        // Apply a color shift for each instance
        replicatorLayer.instanceBlueOffset = -0.1
        replicatorLayer.instanceGreenOffset = -0.1
        
        // Create a sublayer and place it inside the replicator
        let layer = CALayer()
        layer.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
        layer.position = view.layer.position
        layer.backgroundColor = UIColor.white.cgColor
        
        replicatorLayer.addSublayer(layer)
    }
    
    // MARK: - CATiledLayer
    private func testTiledLayer() {
        view.addSubview(scrollView)
        
        // Add the tiled layer
        let tileLayer = CATiledLayer()
        tileLayer.frame = CGRect(x: 0, y: 0, width: 2048, height: 2048)
        tileLayer.delegate = self
        scrollView.layer.addSublayer(tileLayer)
        
        // Configure the scroll view.
        scrollView.contentSize = tileLayer.frame.size
        
        // Draw layer
        tileLayer.setNeedsDisplay()
    }
    
    // MARK: - CAEmitterLayer
//    private func testEmitterLayer() {
//        let cell = CAEmitterCell()
//        cell.birthRate = 10
//        cell.lifetime = 10
//        cell.velocity = 100
//        cell.scale = 1.0
//
//        cell.emissionRange = CGFloat.pi * 2.0
//        cell.contents = UIImage(named: "RadialGradient")!.cgImage
//
//        cell.emissionRange = 1.5
//
//        let emitterLayer = CAEmitterLayer()
//        emitterLayer.emitterPosition = CGPoint(x: 320, y: 320)
//        emitterLayer.renderMode = .unordered
//        emitterLayer.emitterCells = [cell]
//
//        view.layer.addSublayer(emitterLayer)
//    }
    
    private func testEmitterLayer() {
        view.backgroundColor = UIColor.black
        // Create particle emitter layer
//        var replicatorLayer = CAReplicatorLayer()
//        emitter.position = view.layer.position
//        emitter.bounds = view.bounds
        view.layer.addSublayer(emitter)

        // Configure emitter
        emitter.renderMode = .additive
        emitter.emitterPosition = view.center

        // Create a particle template
        let cell = CAEmitterCell()
        cell.contents = UIImage(named: "Spark")?.cgImage
        cell.birthRate = 150
        cell.lifetime = 5
        cell.color = UIColor(red: 1.0, green: 0.5, blue: 0.1, alpha: 1.0).cgColor
        cell.alphaSpeed = -0.4
        cell.velocity = 50
        cell.velocityRange = 50
        cell.emissionRange = .pi * 2.0

        // Add particle template to emitter
        emitter.emitterCells = [cell]
    }
}

extension LayersViewController: CALayerDelegate {
    
    func draw(_ layer: CALayer, in ctx: CGContext) {
        guard let layer = layer as? CATiledLayer else  {
            return
        }
        
        // Determine tile coordinate
        let bounds = ctx.boundingBoxOfClipPath
        let x: Int = Int(floor(bounds.origin.x / layer.tileSize.width))
        let y: Int = Int(floor(bounds.origin.y / layer.tileSize.height))
        
        // Load tile image
        let imgName = "Snowman_0\(x)_0\(y)"
        let imgPath = Bundle.main.path(forResource: imgName, ofType: "jpg")
        guard let imgLocation = imgPath else { return }
        let tileImage = UIImage(contentsOfFile: imgLocation)
        
        // Draw tile
        UIGraphicsPushContext(ctx)
        tileImage?.draw(in: bounds)
        UIGraphicsPopContext()
    }
}
