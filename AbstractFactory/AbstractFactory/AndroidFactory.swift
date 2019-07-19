//
//  AndroidFactory.swift
//  AbstractFactory
//
//  Created by pro648 on 2019/7/19.
//  Copyright © 2019 pro648. All rights reserved.
//

import Foundation

class AndroidFactory: AbstractGUIFactory {
    func createButton() -> Button {
        return AndroidButton()
    }
    
    func createAlert() -> Alert {
        return AndroidAlert()
    }
}
