//
//  ViewController.swift
//  AdapterPattern
//
//  Created by pro648 on 2019/7/25.
//  Copyright © 2019 pro648. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // 1
        let authService: AuthenticationService = GoogleAuthenticatorAdapter()
        
        // 2
        authService.login(email: "user@example.com", password: "password", success: { (user, token) in
            
            // 3
            print("Auth succeeded: \(user.email), \(token.value)")
        }) { (error) in
            
            // 4
            if let error = error {
                print("Auth failed with error: \(error)")
            } else {
                print("Auth failed with error: no error provided")
            }
        }
    }
}

