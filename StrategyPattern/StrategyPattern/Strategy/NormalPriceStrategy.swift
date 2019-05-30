//
//  NormalPriceStrategy.swift
//  StrategyPattern
//
//  Created by pro648 on 2019/5/25.
//  Copyright © 2019 pro648. All rights reserved.
//

class NormalPriceStrategy: CheckoutStrategy {
    func getFinalPrice(with itemPrices: [Int]) -> Int {
        // do calculation
        
        return 90 + 75 + 20
    }
}
