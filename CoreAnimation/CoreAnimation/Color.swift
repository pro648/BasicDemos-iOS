//
//  Color.swift
//  CoreAnimation
//
//  Created by pro648 on 2020/8/9.
//  Copyright © 2020 pro648. All rights reserved.
//

import UIKit

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX)
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(red: .random(), green: .random(), blue: .random(), alpha: 1.0)
    }
}
