//
//  Router.swift
//  ResponderChain
//
//  Created by pro648 on 2020/9/27.
//  

import UIKit

extension UIResponder {
    
    /// 将事件转发给下一 responder
    /// - Parameters:
    ///   - event: 事件名称
    ///   - userInfo: 事件附带的额外信息
    @objc func routerEvent(with event: String, userInfo: [String:String]) {
        print(NSStringFromClass(type(of: self)) + "  " + #function)
        
        self.next?.routerEvent(with: event, userInfo: userInfo)
    }
}
