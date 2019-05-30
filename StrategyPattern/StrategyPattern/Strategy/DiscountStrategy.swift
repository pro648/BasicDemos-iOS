//
//  DiscountStrategy.swift
//  StrategyPattern
//
//  Created by pro648 on 2019/5/25.
//  Copyright © 2019 pro648. All rights reserved.
//

class DiscountStrategy: CheckoutStrategy {
    func getFinalPrice(with itemPrices: [Int]) -> Int {
        // do calculation
        
        return Int((90 + 75) * 0.9) + 20
    }
}
