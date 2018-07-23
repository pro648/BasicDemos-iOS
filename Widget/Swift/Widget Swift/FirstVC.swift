//
//  FirstVC.swift
//  Widget Swift
//
//  Created by pro648 on 18/7/22
//  Copyright © 2018年 pro648. All rights reserved.
//

import UIKit
import NotificationCenter

class FirstVC: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func handleButtonTapped(_ sender: UIButton) {
        if sender.titleLabel?.text == "Show Widget" {
            NCWidgetController().setHasContent(true, forWidgetWithBundleIdentifier: "pro648.Widget-Swift.UsedSpaceWidget")
            sender.setTitle("Hide Widget", for: .normal)
        } else {
            NCWidgetController().setHasContent(false, forWidgetWithBundleIdentifier: "pro648.Widget-Swift.UsedSpaceWidget")
            sender.setTitle("Show Widget", for: .normal)
        }
    }
}
