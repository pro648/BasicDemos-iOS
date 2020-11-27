//
//  ViewController.swift
//  VisualEffectView
//
//  Created by pro648 on 2020/11/27.
//
//  详细介绍：https://github.com/pro648/tips/blob/master/sources/%E9%AB%98%E6%96%AF%E6%A8%A1%E7%B3%8A%E5%8E%9F%E7%90%86%E3%80%81%E4%BB%A5%E5%8F%8A%E5%A6%82%E4%BD%95%E4%BD%BF%E7%94%A8UIVisualEffectView%E5%AE%9E%E7%8E%B0%E6%A8%A1%E7%B3%8A%E6%95%88%E6%9E%9C.md

import UIKit
import WebKit

class ViewController: UIViewController {
    #warning("pro648.VisualEffectView")
    
    private var visualEffectVisible = false
    private let hiddenFrame = CGRect(x: 0, y: UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width, height: 200)
    private let visibleFrame = CGRect(x: 0, y: UIScreen.main.bounds.size.height - 200, width: UIScreen.main.bounds.size.width, height: 200)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        view.addSubview(bottomView)
        
        addVisualEffect()
    }
    
    private func addVisualEffect() {
        
        // 系统开启了「降低透明度」
        guard !UIAccessibility.isReduceTransparencyEnabled else {
            bottomView.backgroundColor = .lightGray
            bottomView.addSubview(houseLabel)
            houseLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                houseLabel.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor),
                houseLabel.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor),
            ])
            return
        }
        
        // 选用 dark 类型 blur
        let blurEffect = UIBlurEffect(style: .dark)
        // blur effect 需要添加到 UIVisualEffectView
        let blurView = UIVisualEffectView(effect: blurEffect)
        bottomView.addSubview(blurView)
        
        blurView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            blurView.heightAnchor.constraint(equalTo: bottomView.heightAnchor),
            blurView.widthAnchor.constraint(equalTo: bottomView.widthAnchor),
        ])
        
        // 子视图不能直接添加到blurView，只能添加到contentView。
//        blurView.contentView.addSubview(houseLabel)
//        houseLabel.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            houseLabel.centerXAnchor.constraint(equalTo: blurView.centerXAnchor),
//            houseLabel.centerYAnchor.constraint(equalTo: blurView.centerYAnchor),
//        ])
        
        // 使用之前的blurEffect创建UIVibrancyEffect
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
        // UIVibrancyEffect 必须添加到配置了UIBlurEffect的UIVisualEffectView的contentView上，否则不会有效果。
        blurView.contentView.addSubview(vibrancyView)

        vibrancyView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            vibrancyView.heightAnchor.constraint(equalTo: blurView.heightAnchor),
            vibrancyView.widthAnchor.constraint(equalTo: blurView.widthAnchor),
            vibrancyView.centerXAnchor.constraint(equalTo: blurView.centerXAnchor),
            vibrancyView.centerYAnchor.constraint(equalTo: blurView.centerYAnchor),
        ])
        
        // 将文本添加到 UIVibrancyEffect 视图的contentView上。添加到vibrancyView上的所有控件都会具有 vibrancy effect。
        vibrancyView.contentView.addSubview(houseLabel)
        houseLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            houseLabel.centerXAnchor.constraint(equalTo: vibrancyView.centerXAnchor),
            houseLabel.centerYAnchor.constraint(equalTo: vibrancyView.centerYAnchor),
        ])
    }
    
    lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.load(URLRequest(url: URL(string: "https://github.com/pro648/tips")!))
        return webView
    }()
    
    lazy var bottomView: UIView = {
        let bottomView = UIView(frame: hiddenFrame)
        return bottomView
    }()
    
    lazy var houseLabel: UILabel = {
        let houseLabel = UILabel()
        houseLabel.text = "Growing Strong"
        houseLabel.font = .systemFont(ofSize: 30)
        houseLabel.textAlignment = .center
        return houseLabel
    }()
    
    @IBAction func barButtonTapped(_ sender: UIBarButtonItem) {
        visualEffectVisible = !visualEffectVisible
        
        var bottomFrame = CGRect()
        if visualEffectVisible {
            // 显示
            bottomFrame = CGRect(x: 0, y: view.bounds.size.height - 200, width: view.bounds.size.width, height: 200)
        } else {
            // 隐藏
            bottomFrame = CGRect(x: 0, y: view.bounds.size.height, width: view.bounds.size.width, height: 200)
        }
        
        let animator = UIViewPropertyAnimator(duration: 2.0, dampingRatio: 0.2) {
            self.bottomView.frame = bottomFrame
        }
        animator.startAnimation()
    }
}

