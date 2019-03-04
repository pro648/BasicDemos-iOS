//  OneTimeCodeViewController.swift
//  PasswordAutofill
//
//  Created by pro648 on 2019/2/23
//  Copyright © 2019 pro648. All rights reserved.
//

import UIKit

class OneTimeCodeViewController: ParentViewController {
    
    @IBOutlet weak var oneTimeCodeField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.setHidesBackButton(true, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        oneTimeCodeField.keyboardType = .numberPad
        oneTimeCodeField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        oneTimeCodeField.resignFirstResponder()
        oneTimeCodeField.text = nil
    }
    
    @IBAction func submitTapped(_ sender: Any) {
        oneTimeCodeField.resignFirstResponder()
        
        performSegue(withIdentifier: "Verified", sender: nil)
    }
}
