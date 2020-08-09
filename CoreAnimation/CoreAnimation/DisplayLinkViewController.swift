//
//  DisplayLinkViewController.swift
//  CoreAnimation
//
//  Created by pro648 on 2020/8/9.
//  Copyright © 2020 pro648. All rights reserved.
//
//  详细介绍：[计时器CADisplayLink](https://github.com/pro648/tips/blob/master/sources/%E8%AE%A1%E6%97%B6%E5%99%A8CADisplayLink.md)

import UIKit
import SafariServices

class DisplayLinkViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createDisplayLink()
    }
    
    override func changeLayerProperty() {
        let sfVC = SFSafariViewController(url: URL(string: "https:www.baidu.com")!)
        show(sfVC, sender: nil)
    }
    
    // MARK: - CADisplayLink
    
    private func createDisplayLink() {
        let displayLink = CADisplayLink(target: self, selector: #selector(self.linkTriggered(_:)))
        displayLink.preferredFramesPerSecond = 1
        displayLink.add(to: .main, forMode: .default)
        
        // 当前设备的帧率
        print("maximumFramesPerSecond:\(UIScreen.main.maximumFramesPerSecond)")
        
//        displayLink.isPaused = true
//        displayLink.invalidate()
        
    }
    
    @objc private func linkTriggered(_ displaylink: CADisplayLink) {
        print("timestamp:\(displaylink.timestamp)")
        
        // duration是两帧间隔，不是两次回调间隔。
        print("duration:\(displaylink.duration)")

        // 两次回调间隔。
        print("Callback:\(displaylink.targetTimestamp - displaylink.timestamp)")

        // 当前帧率
        print("Actual frames per second: \(1 / (displaylink.targetTimestamp - displaylink.timestamp))")
        
        // 计算平方根的和。超过当前帧 targetTimestamp 时，停止计算。
//        displaylink.targetTimestamp - displaylink.timestamp
//        var sqrtSum = 0.0
//        for i in 0 ..< Int.max {
//            sqrtSum += sqrt(Double(i))
//
//            if CACurrentMediaTime() >= displaylink.targetTimestamp {
//                print("Break at i = \(i), sqrtSum:\(sqrtSum)")
//                break
//            }
//        }
    }
}
