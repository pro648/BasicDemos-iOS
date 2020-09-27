//
//  ButtonViewController.swift
//  ResponderChain
//
//  Created by pro648 on 2020/9/27.
//  

import UIKit

/// 测试如何增大、减小 UIButton 可点击区域
class ButtonViewController: UIViewController {
    
    lazy var button: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .lightGray
        button.setTitle("pro648", for: .normal)
        button.addTarget(self, action: #selector(self.buttonTapped(_:)), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        
        button.bounds = CGRect(x: 0, y: 0, width: 120, height: 40)
        button.center = view.center
        button.expand(edgeInset: UIEdgeInsets(top: -30, left: -30, bottom: -30, right: -30))
//        button.expand(edgeInset: .zero)
        view.addSubview(button)
    }
    
    @objc private func buttonTapped(_: UIButton) {
        print(#function)
    }
}
