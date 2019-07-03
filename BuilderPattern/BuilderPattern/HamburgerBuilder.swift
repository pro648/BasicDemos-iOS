//
//  HamburgerBuilder.swift
//  BuilderPattern
//
//  Created by pro648 on 2019/7/2.
//  Copyright © 2019 pro648. All rights reserved.
//

// MARK: - Builder

public class HamburgerBuilder {
    
    // meat、sauces、toppings 为变量，使用 private(set) 限制为只有 HamburgerBuilder 可以修改。
    public private(set) var meat: Meat = .beef
    public private(set) var sauces: Sauces = []
    public private(set) var toppings: Toppings = []
    private var soldOutMeats: [Meat] = [.kitten]
    
    // 因为 property 使用了 private(set)，必须提供 public 方法修改属性。
    public func addSauces(_ sauce: Sauces) {
        sauces.insert(sauce)
    }
    
    public func removeSauces(_ sauce: Sauces) {
        sauces.remove(sauce)
    }
    
    public func addToppings(_ topping: Toppings) {
        toppings.insert(topping)
    }
    
    public func removeToppings(_ topping: Toppings) {
        toppings.remove(topping)
    }
    
    public func setMeat(_ meat: Meat) throws {
        guard isAvailable(meat) else { throw Error.soldOut }
        self.meat = meat
    }
    
    public func isAvailable(_ meat: Meat) -> Bool {
        return !soldOutMeats.contains(meat)
    }
    
    public enum Error: Swift.Error {
        case soldOut
    }
    
    public func build() -> Hamburger {
        return Hamburger(meat: meat, sauce: sauces, toppings: toppings)
    }
}
