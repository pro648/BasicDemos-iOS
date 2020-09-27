//
//  ViewController.swift
//  ResponderChain
//
//  Created by pro648 on 2020/9/24.
//
//  详细介绍：https://github.com/pro648/tips/blob/master/sources/%E4%BA%8B%E4%BB%B6%E4%BC%A0%E9%80%92%E5%92%8C%E5%93%8D%E5%BA%94%E9%93%BE%EF%BC%88Responder%20Chain%EF%BC%89.md

import UIKit

class ViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    var items: [Item] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        items = [
            Item(title: "事件传递顺序", clsNameStr: NSStringFromClass(FindResponderVC.self)),
            Item(title: "增大按钮点击区域", clsNameStr: NSStringFromClass(ButtonViewController.self)),
            Item(title: "Cell 事件统一路由至控制器处理", clsNameStr: NSStringFromClass(RouterEventVC.self))
        ]
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let item = items[indexPath.row]
        cell.textLabel?.text = item.title
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = items[indexPath.row]
        guard let vc = NSClassFromString(item.clsNameStr) as? UIViewController.Type else { return }
        show(vc.init(), sender: nil)
    }
}


