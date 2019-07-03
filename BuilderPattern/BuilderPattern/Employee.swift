//
//  Employee.swift
//  BuilderPattern
//
//  Created by pro648 on 2019/7/2.
//  Copyright © 2019 pro648. All rights reserved.
//

// Director

public class Employee {
    public func createCombol() throws -> Hamburger {
        let builder = HamburgerBuilder()
        try builder.setMeat(.beef)
        builder.addSauces(.secret)
        builder.addToppings([.lettuce, .tomatoes, .pickles])
        return builder.build()
    }
    
    public func createKittenSpecial() throws -> Hamburger {
        let builder = HamburgerBuilder()
        try builder.setMeat(.kitten)
        builder.addSauces(.mustard)
        builder.addToppings([.lettuce, .tomatoes])
        return builder.build()
    }
}
