//
//  RouterEventVC.swift
//  ResponderChain
//
//  Created by pro648 on 2020/9/27.
//  

import UIKit

/// 路由管理控制器
/// Cell 中事件统一路由至当前控制器处理
class RouterEventVC: UIViewController {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .systemBackground
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(RouterEventCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.rowHeight = 44
        return tableView
    }()
    private let cellIdentifier = "RouterEventCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    }
}

extension RouterEventVC {
    // 统一处理所有事件
    override func routerEvent(with event: String, userInfo: [String : String]) {
        if event == "firstButton" {
            print("firstButton Clicked")
        } else if event == "secondButton" {
            print("secondButton Clicked")
        } else {
            print("Something else Clicked")
        }
    }
}

extension RouterEventVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! RouterEventCell
        
        
        return cell
    }
}

extension RouterEventVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
