//
//  AuthenticationService.swift
//  AdapterPattern
//
//  Created by pro648 on 2019/7/25.
//  Copyright © 2019 pro648. All rights reserved.
//

import Foundation

public protocol AuthenticationService {
    func login(email: String,
               password: String,
               success:@escaping (User, Token) -> Void,
               failure:@escaping (Error?) -> Void)
}

public struct User {
    public let email: String
    public let password: String
}

public struct Token {
    public let value: String
}
