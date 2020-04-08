//
//  DetailViewController.swift
//  SQLite
//
//  Created by pro648 on 2020/4/5.
//  Copyright © 2020 pro648. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    typealias EditInfoBlock = () -> ()
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var ageField: UITextField!
    @IBOutlet weak var updateLabel: UILabel!
    @IBOutlet weak var insertLabel: UILabel!
    
    var editInfoBlock: EditInfoBlock?
    
    var uniqueId: Int32  = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let barButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveButtonTapped))
        navigationItem.rightBarButtonItem = barButtonItem
        
        if uniqueId != 0 {
            let detail = SQLiteManager.shared.query(uniqueId: uniqueId)
            nameField.text = detail?.name
            ageField.text = detail?.age
            updateLabel.text = "Update Date: \(detail?.updateDate ?? "")"
            insertLabel.text = "Insert Date: \(detail?.insertDate ?? "")"
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        nameField.becomeFirstResponder()
    }
    
    @objc func saveButtonTapped() {
        if uniqueId == 0 {
            SQLiteManager.shared.insert(contact: Contact(id: 0, name: nameField.text ?? "", age: ageField.text ?? ""))
        } else {
            SQLiteManager.shared.update(contact: Contact(id: uniqueId, name: nameField.text ?? "", age: ageField.text ?? ""))
        }
        editInfoBlock?()
        self.navigationController?.popViewController(animated: true)
    }
    
}
