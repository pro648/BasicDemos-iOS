//
//  TotalPriceViewController.swift
//  StrategyPattern
//
//  Created by pro648 on 2019/5/25.
//  Copyright © 2019 pro648. All rights reserved.
//

import UIKit

enum CheckoutType {
    case normal
    case discount
    case freeShipping
}

class TotalPriceViewController: UIViewController {
    
    var finalPrice: Int = 0 {
        didSet {
            finalPriceLabel.text = "Total Price is \(finalPrice)"
        }
    }
    
    lazy var finalPriceLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(finalPriceLabel)
        
        finalPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            finalPriceLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            finalPriceLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            ])
    }
    
//    public func bindProperties(itemPrices: [Int], checkoutType: CheckoutType) {
//        switch checkoutType {
//        case .normal:
//            finalPrice = getFinalPriceWithNormal(itemPrices: itemPrices)
//
//        case .discount:
//            finalPrice = getFinalPriceWithDiscount(itemPrices: itemPrices)
//
//        case .freeShipping:
//            finalPrice = getFinalPriceWithFreeShipping(itemPrices: itemPrices)
//        }
//    }
//
//    private func getFinalPriceWithNormal(itemPrices: [Int]) -> Int {
//        // do calculation
//
//        return 90 + 75 + 20
//    }
//
//    private func getFinalPriceWithDiscount(itemPrices: [Int]) -> Int {
//        // do calculation
//
//        return Int((90 + 75) * 0.9) + 20
//    }
//
//    private func getFinalPriceWithFreeShipping(itemPrices: [Int]) -> Int {
//        // do calculation
//
//        return 90 + 75
//    }
    
    
    public func bindProperties(itemPrices:[Int], checkoutStrategy: CheckoutStrategy) {
        finalPrice = checkoutStrategy.getFinalPrice(with: itemPrices)
    }
}
