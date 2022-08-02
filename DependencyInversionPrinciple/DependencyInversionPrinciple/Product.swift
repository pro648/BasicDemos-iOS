//
//  Product.swift
//  DependencyInversionPrinciple
//
//  Created by ad on 2022/8/1.
//

import UIKit

/*
struct Product {
    let name: String
    let cost: Int
    let image: UIImage
}
 */

protocol ProductProtocol {
    var name: String { get }
    var cost: Int { get }
    var image: UIImage { get }
}

struct Product: ProductProtocol {
    let name: String
    let cost: Int
    let image: UIImage
}
