//
//  AbstractGUIFactory.swift
//  AbstractFactory
//
//  Created by pro648 on 2019/7/19.
//  Copyright © 2019 pro648. All rights reserved.
//

import Foundation

protocol AbstractGUIFactory {
    func createButton() -> Button
    func createAlert() -> Alert
}
