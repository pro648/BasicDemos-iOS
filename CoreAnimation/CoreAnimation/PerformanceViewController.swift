//
//  PerformanceViewController.swift
//  CoreAnimation
//
//  Created by pro648 on 2020/8/9.
//  Copyright © 2020 pro648. All rights reserved.
//
//  详细介绍：[影响动画性能的因素及如何使用 Instruments 检测](https://github.com/pro648/tips/blob/master/sources/%E5%BD%B1%E5%93%8D%E5%8A%A8%E7%94%BB%E6%80%A7%E8%83%BD%E7%9A%84%E5%9B%A0%E7%B4%A0%E5%8F%8A%E5%A6%82%E4%BD%95%E4%BD%BF%E7%94%A8%20Instruments%20%E6%A3%80%E6%B5%8B.md)

import UIKit

/// 使用 Instruments 的 Core Animation 模版监测性能
class PerformanceViewController: BaseViewController {
    
    var items = [Dictionary<String, Any>]()
    var tableView = UITableView(frame: .zero, style: .plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var array = [Dictionary<String, Any>]()
        for _ in 0...3000 {
            array.append(["name": self.randomName(), "image": self.randomAvatar()])
        }
        items = array
        
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    private func randomName() -> String {
        let first = ["Alice", "Bill", "Charles", "Dan", "Dave", "Ethan", "Frank"]
        let last = ["Appleseed", "Bandicoot", "Caravan", "Dabble", "Ernest", "Fortune"]
        
        let index1 = arc4random_uniform(UInt32(first.count))
        let index2 = arc4random_uniform(UInt32(last.count))
        
        return String(first[Int(index1)] + last[Int(index2)])
    }
    
    private func randomAvatar() -> String {
        let images = ["Man", "Igloo", "Cone", "Spaceship", "Anchor", "Key"]
        let idx = arc4random_uniform(UInt32(images.count))
        
        return images[Int(idx)]
    }
    
    override func changeLayerProperty() {
        
    }
}

extension PerformanceViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        let dict: Dictionary = items[indexPath.row]
        
        let filePath = Bundle.main.path(forResource: dict["image"] as? String, ofType: "png")
        
        cell.imageView?.image = UIImage(contentsOfFile: filePath ?? "")
//        cell.imageView?.image = UIImage(named: dict["image"] as! String, in: .main, compatibleWith: nil)
        cell.textLabel?.text = dict["name"] as? String
        
        // set image shadow
        cell.imageView?.layer.shadowOffset = CGSize(width: 0, height: 5)
        cell.imageView?.layer.shadowOpacity = 0.75
        cell.clipsToBounds = true
        
        // set text shadow
        cell.textLabel?.backgroundColor = UIColor.clear
        cell.textLabel?.layer.shadowOffset = CGSize(width: 0, height: 2)
        cell.textLabel?.layer.shadowOpacity = 0.5
        
        // rasterize
        cell.layer.shouldRasterize = true
        cell.layer.rasterizationScale = UIScreen.main.scale
        
        return cell
    }
}
