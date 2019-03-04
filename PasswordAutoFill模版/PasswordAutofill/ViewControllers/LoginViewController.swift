//  LoginViewController.swift
//  PasswordAutofill
//
//  Created by pro648 on 2019/2/23
//  Copyright © 2019 pro648. All rights reserved.
//

import UIKit

class LoginViewController: ParentViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        usernameField.keyboardType = .emailAddress
        passwordField.isSecureTextEntry = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        view.endEditing(true)
    }
    
    @IBAction func signIn(_ sender: UIButton) {
        view.endEditing(true)
        
        guard let username = usernameField.text,
            let password = passwordField.text,
            !username.isEmpty,
            !password.isEmpty
            else {
                fillInFieldsReminder()
                return
        }
        
        signInButton.isEnabled = false
        
        API.login(username, password: password) { (result) in
            self.signInButton.isEnabled = true
            switch result {
            case .success:
                self.performSegue(withIdentifier: "Logged In", sender: nil)
                
            case .failure(let error):
                self.showAlert("Error", message: error ?? "Login Failed")
            }
        }
    }
}
