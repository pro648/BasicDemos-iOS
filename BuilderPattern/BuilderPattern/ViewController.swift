//
//  ViewController.swift
//  BuilderPattern
//
//  Created by pro648 on 2019/7/2.
//  Copyright © 2019 pro648. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let burgerFlipper = Employee()
        
        guard let combol = try? burgerFlipper.createCombol() else {
            print("Sorry, no beef burgers here...")
            return
        }
        print("Beef burgers " + combol.description)
        
        guard let kittenBurger = try? burgerFlipper.createKittenSpecial() else {
            print("Sorry, no kitten burgers here...")
            return
        }
        print("Nom nom nom " + kittenBurger.description)
    }


}

