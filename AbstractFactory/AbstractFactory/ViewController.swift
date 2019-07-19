//
//  ViewController.swift
//  AbstractFactory
//
//  Created by pro648 on 2019/7/19.
//  Copyright © 2019 pro648. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let androidBuilder = GUIBuilder(style: .Android)
        
        // 具体应用
        let androidAlert = androidBuilder.buildAlert()
        androidAlert.setTitle("github.com/pro648")
        androidAlert.show()
        
        let androidButton = androidBuilder.buildButton()
        androidButton.setTitle("Be together, Not the same.")
        androidButton.show()
        
        let iOSBuilder = GUIBuilder(style: .iOS)
        
        let iOSAlert = iOSBuilder.buildAlert()
        iOSAlert.setTitle("Knowledge is power.")
        iOSAlert.show()
        
        let iOSButton = iOSBuilder.buildButton()
        iOSButton.setTitle("Power is power.")
        iOSButton.show()
    }


}

