//
//  ViewController.swift
//  PrototypePattern
//
//  Created by pro648 on 2019/8/13.
//  Copyright © 2019 pro648. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // 创建 Monster 的实例，复制后得到 monster2
        let monster = Monster(health: 700, level: 37)
        let monster2 = monster.copy()
        print("Watch out! That monster's level is \(monster2.level)")
        
        // 创建 EyeballMonster 的实例，复制后得到 eyeball2
        let eyeball = EyeballMonster(health: 3002, level: 60, redness: 648)
        let eyeball2 = eyeball.copy()
        print("Eww! Its eyeball redness is \(eyeball2.redness)")
        
//        let eyeballMonster3 = EyeballMonster(monster)
    }


}

