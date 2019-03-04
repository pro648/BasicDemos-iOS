//  ParentViewController.swift
//  PasswordAutofill
//
//  Created by pro648 on 2019/2/23
//  Copyright © 2019 pro648. All rights reserved.
//

import UIKit

class ParentViewController: UIViewController {
    var keyboardDismisser: UITapGestureRecognizer!

    @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func fillInFieldsReminder() -> Void {
        showAlert("Error", message: "Fill in all the fields, please.")
    }
    
    func showAlert(_ title: String, message: String? = nil, completion: (() -> Void)? = nil) -> Void {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (_) in
            completion?()
        }
        alertController.addAction(OKAction)
        present(alertController, animated: true, completion: nil)
    }
}
