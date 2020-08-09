//
//  BaseViewController.swift
//  CoreAnimation
//
//  Created by pro648 on 2020/8/9.
//  Copyright © 2020 pro648. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    public var modified = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        let changeItem = UIBarButtonItem(title: "Change", style: .plain, target: self, action: #selector(self.changeLayerProperty))
        navigationItem.rightBarButtonItem = changeItem
    }
    
    @objc func changeLayerProperty() {
        fatalError("Subclass must override this method")
    }
    
    
}
