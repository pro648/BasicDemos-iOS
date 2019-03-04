//  SignupViewController.swift
//  PasswordAutofill
//
//  Created by pro648 on 2019/2/23
//  Copyright © 2019 pro648. All rights reserved.
//

import UIKit

class SignupViewController: ParentViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        usernameField.keyboardType = .emailAddress
        passwordField.isSecureTextEntry = true
        usernameField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        view.endEditing(true)
        if API.token == nil {
            
        } else {
            API.logout()
        }
    }
    
    @IBAction func signUp(_ sender: Any) {
        view.endEditing(true)
        
        guard
            let username = usernameField.text,
            let password = passwordField.text,
            !username.isEmpty, !password.isEmpty
            else {
                fillInFieldsReminder()
                return
        }
        
        signUpButton.isEnabled = false
        
        API.register(username, password: password) { (result) in
            self.signUpButton.isEnabled = true
            
            switch result {
            case .success:
                self.showAlert("Signed Up!", message: "Log in to get motivated", completion: {
                    self.dismiss(animated: true, completion: nil)
                })
                
            case .failure(let error):
                self.showAlert("Error", message: error ?? "Sign Up Failed", completion: nil)
            }
        }
    }
    
    @IBAction func cancelSignUp(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
