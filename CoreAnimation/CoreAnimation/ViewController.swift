//
//  ViewController.swift
//  CoreAnimation
//
//  Created by pro648 on 2020/8/9.
//  Copyright © 2020 pro648. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var tableView: UITableView!
    var items: [Item] = []
    
    private let reuseIdentifier = "reuseIdentifier"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Core Animation"
        view.backgroundColor = .white
        
        items = [
            Item(title: "Shadow Path", clsNameStr: NSStringFromClass(ShadowPathViewController.self)),
            Item(title: "Transform", clsNameStr: NSStringFromClass(TransformViewController.self)),
            Item(title: "Layers", clsNameStr: NSStringFromClass(LayersViewController.self)),
            Item(title: "Reflection", clsNameStr: NSStringFromClass(ReflectionViewController.self)),
            Item(title: "Explicitly", clsNameStr: NSStringFromClass(ExplicitlyViewController.self)),
            Item(title: "Layer Time", clsNameStr: NSStringFromClass(LayerTimeViewController.self)),
            Item(title: "CADisplayLink", clsNameStr: NSStringFromClass(DisplayLinkViewController.self)),
            Item(title: "Instruments", clsNameStr: NSStringFromClass(PerformanceViewController.self)),
            Item(title: "Image IO", clsNameStr: NSStringFromClass(ImageIOViewController.self)),
            Item(title: "Layer Performance", clsNameStr: NSStringFromClass(LayerPerformanceViewController.self)),
        ]
        
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
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
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        let item = items[indexPath.row]
        cell.textLabel?.text = item.title
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 3 {
            let storyboard = UIStoryboard.init(name: "Main", bundle: .main)
            let vc = storyboard.instantiateViewController(withIdentifier: "Reflection")
            show(vc, sender: true)
        } else if indexPath.row == 5 {
            let storyboard = UIStoryboard.init(name: "Main", bundle: .main)
            let vc = storyboard.instantiateViewController(withIdentifier: "LayerTimeViewController")
            show(vc, sender: true)
        } else {
            let item = items[indexPath.row]
            guard let vc = NSClassFromString(item.clsNameStr) as? UIViewController.Type else { return }
            show(vc.init(), sender: nil)
        }
    }
}
