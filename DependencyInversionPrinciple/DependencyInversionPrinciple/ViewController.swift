//
//  ViewController.swift
//  DependencyInversionPrinciple
//
//  Created by ad on 2022/8/1.
//
//  详细介绍：https://github.com/pro648/tips/blob/master/sources/%E4%BE%9D%E8%B5%96%E5%8F%8D%E8%BD%AC%E5%8E%9F%E5%88%99.md

import UIKit

class ViewController: UIViewController {
    /*
    private let network: Network
    private var products: [Product]
     */
    private let network: NetworkProtocol // Abstraction dependency
    private var products: [ProductProtocol] // Abstraction dependency
    private let userId: String = "user-id"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        getProducts()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func loadView() {
        view = UIView()
    }
    
    /*
    init(network: Network, products: [Product]) {
        self.network = network
        self.products = products
        super.init(nibName: nil, bundle: nil)
    }
     */
    
    init(network: NetworkProtocol, products: [ProductProtocol]) { // Abstraction dependency
        self.network = network
        self.products = products
        super.init(nibName: nil, bundle: nil)
    }
     
    private func getProducts() {
        network.getProducts(for: userId) { [weak self] products in
            self?.products = products
        }
    }
}
