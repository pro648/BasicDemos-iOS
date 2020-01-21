//
//  ViewController.swift
//  Timer
//
//  Created by pro648 on 2020/1/19.
//  Copyright © 2020 pro648. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var balloon: Balloon!
    
    var taskList: [Task] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(presentAlertController(_:)))
    }
}

// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.cellForRow(at: indexPath) as? TaskTableViewCell else { return }
        
        cell.updateState()
    }
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
        
        if let cell = cell as? TaskTableViewCell {
            cell.task = taskList[indexPath.row]
        }
        
        return cell
    }
}

// MARK: - Actions
extension ViewController {
    @objc func presentAlertController(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Task Name", message: nil, preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Task name"
            textField.autocapitalizationType = .sentences
        }
        
        let createAction = UIAlertAction(title: "OK", style: .default) { [weak self, weak alertController] _ in
            guard let self = self,
                let text = alertController?.textFields?.first?.text else {
                    return
            }
            
            DispatchQueue.main.async {
                let task = Task(name: text)
                self.taskList.append(task)
                let indexPath = IndexPath(row: self.taskList.count - 1, section: 0)
                
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: [indexPath], with: .top)
                self.tableView.endUpdates()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(createAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
