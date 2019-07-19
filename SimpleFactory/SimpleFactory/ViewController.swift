//
//  ViewController.swift
//  SimpleFactory
//
//  Created by pro648 on 2019/7/17.
//  Copyright © 2019 pro648. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        var pro648 = JobApplicant(name: "pro648",
                                   email: "pro648@example.com",
                                   status: .new)
        let emailFactory = EmailFactory(senderEmail: "about@example.com")
        
        print(emailFactory.createEmail(to: pro648), "\n")
        
        pro648.status = .interview
        print(emailFactory.createEmail(to: pro648), "\n")
        
        pro648.status = .hired
        print(emailFactory.createEmail(to: pro648), "\n")
    }
}

