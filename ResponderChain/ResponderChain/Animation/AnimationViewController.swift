//
//  AnimationViewController.swift
//  ResponderChain
//
//  Created by ad on 2022/2/28.
//

import UIKit

class AnimationViewController: UIViewController {
    private let startFrame = CGRect(x: 30, y: 100, width: 110, height: 110)
    private let finalFrame = CGRect(x: 100, y: 700, width: 110, height: 110)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        animatedView.frame = startFrame
        view.addSubview(animatedView)
        startButton.center = CGPoint(x: view.bounds.size.width / 2.0, y: 100)
        view.addSubview(startButton)
    }
    
    private lazy var animatedView: AnimatedView = {
        let animatedView = AnimatedView()
        return animatedView
    }()

    private lazy var startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Start", for: .normal)
        button.addTarget(self, action: #selector(self.startButtonTapped(_:)), for: .touchUpInside)
        button.sizeToFit()
        return button
    }()
    
    @objc private func startButtonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 10.0, delay: 1.0, options: .allowUserInteraction) {
            self.animatedView.frame = self.finalFrame
        } completion: { _ in
            self.animatedView.frame = self.startFrame
        }

    }
}
