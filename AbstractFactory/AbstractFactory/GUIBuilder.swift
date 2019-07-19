//
//  GUIBuilder.swift
//  AbstractFactory
//
//  Created by pro648 on 2019/7/19.
//  Copyright © 2019 pro648. All rights reserved.
//

import Foundation

class GUIBuilder {
    private var style: Style
    private var guiFactory: AbstractGUIFactory?
    
    public enum Style {
        case iOS
        case Android
    }
    
    init(style: Style) {
        self.style = style
    }
    
    func initGUIFactory() -> Void {
        if nil != guiFactory {
            return
        }
        
        switch style {
        case .iOS:
            guiFactory = iOSFactory()
        case .Android:
            guiFactory = AndroidFactory()
        }
    }
    
    func buildButton() -> Button {
        initGUIFactory()
        return guiFactory!.createButton()
    }
    
    func buildAlert() -> Alert {
        initGUIFactory()
        return guiFactory!.createAlert()
    }
}
