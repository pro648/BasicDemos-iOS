//
//  ViewController.swift
//  SQLite
//
//  Created by pro648 on 2020/4/5.
//  Copyright © 2020 pro648. All rights reserved.
//
//  详细介绍：https://github.com/pro648/tips/wiki/SQLite%E7%9A%84%E4%BD%BF%E7%94%A8%E4%BA%8C

import UIKit

class ViewController: UIViewController {
    
    var tableView: UITableView!
    var items = NSArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView = UITableView.init(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        self.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    @IBAction func addButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        guard let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else {
            return
        }
        detailVC.editInfoBlock = {
            self.reloadData()
        }
        show(detailVC, sender: nil)
    }
    
    private func reloadData() {
        self.items = SQLiteManager.shared.queryAllContacts() as NSArray
        tableView.reloadData()
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        guard let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else {
            return
        }
        
        detailVC.editInfoBlock = {
            self.reloadData()
        }
        
        let contact = items[indexPath.row] as! Contact
        detailVC.uniqueId = contact.id
        
        show(detailVC, sender: nil)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let contextItem = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (contextualAction, view, boolValue) in
            boolValue(true)
            
            let contact = (self?.items[indexPath.row])! as! Contact
            SQLiteManager.shared.delete(contact: contact)
            
            let array: NSMutableArray = NSMutableArray(array: self!.items)
            array.removeObject(at: indexPath.row)
            self?.items = array
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])
        
        return swipeActions
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier")
        if (cell == nil) {
            cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "cellIdentifier")
        }
        
        let contact = items[indexPath.row] as! Contact
        
        cell?.textLabel?.text = contact.name as String
        cell?.detailTextLabel?.text = contact.age as String
        
        return cell!
    }
}
