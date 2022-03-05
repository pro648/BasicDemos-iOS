//
//  TriangleViewController.swift
//  ResponderChain
//
//  Created by ad on 2022/2/24.
//

import UIKit

class TriangleViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(triangleView)
    }
    
    private lazy var triangleView: TriangleView = {
        let triangle = TriangleView(type: .system)
        triangle.frame = CGRect(x: 100, y: 100, width: 140, height: 140)
        return triangle
    }()
}
