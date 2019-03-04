//  MotivationalViewController.swift
//  PasswordAutofill
//
//  Created by pro648 on 2019/2/23
//  Copyright © 2019 pro648. All rights reserved.
//

import UIKit

class MotivationalViewController: UIViewController {
    
    @IBOutlet weak var motivationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.setHidesBackButton(true, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        motivationLabel.isHidden = true
        API.motivationalLottery { (result) in
            if case let .success(motivation) = result {
                self.motivationLabel.text = motivation
            }
            
            self.motivationLabel.isHidden = false
        }
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        API.logout()
        navigationController?.popToRootViewController(animated: true)
    }
}
