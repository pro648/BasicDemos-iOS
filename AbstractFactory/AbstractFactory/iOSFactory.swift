//
//  iOSFactory.swift
//  AbstractFactory
//
//  Created by pro648 on 2019/7/19.
//  Copyright © 2019 pro648. All rights reserved.
//

import Foundation

class iOSFactory: AbstractGUIFactory {
    func createButton() -> Button {
        return iOSButton()
    }
    
    func createAlert() -> Alert {
        return iOSAlert()
    }
}
