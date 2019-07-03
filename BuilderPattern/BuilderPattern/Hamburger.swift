//
//  Hamburger.swift
//  BuilderPattern
//
//  Created by pro648 on 2019/7/2.
//  Copyright © 2019 pro648. All rights reserved.
//

// MARK: - Product

// Hamburger 有 Meat、Sauces、Toppings三个属性。制作完成后不可修改成份。
public struct Hamburger {
    public let meat: Meat
    public let sauce: Sauces
    public let toppings: Toppings
}

extension Hamburger: CustomStringConvertible {
    public var description: String {
        return meat.rawValue + " github.com/pro648"
    }
}

// 每个汉堡有且只有一种肉
public enum Meat: String {
    case beef
    case chicken
    case kitten
    case tofu
}

// OptionSet 允许添加多种Sauces
public struct Sauces: OptionSet {
    public static let mayonnaise = Sauces(rawValue: 1 << 0)
    public static let mustard = Sauces(rawValue: 1 << 1)
    public static let ketchup = Sauces(rawValue: 1 << 2)
    public static let secret = Sauces(rawValue: 1 << 3)
    
    public let rawValue: Int
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct Toppings: OptionSet {
    public static let cheese = Toppings(rawValue: 1 << 0)
    public static let lettuce = Toppings(rawValue: 1 << 1)
    public static let pickles = Toppings(rawValue: 1 << 2)
    public static let tomatoes = Toppings(rawValue: 1 << 3)
    
    public let rawValue: Int
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}
