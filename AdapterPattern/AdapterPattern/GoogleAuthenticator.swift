//
//  GoogleAuthenticator.swift
//  AdapterPattern
//
//  Created by pro648 on 2019/7/25.
//  Copyright © 2019 pro648. All rights reserved.
//

import Foundation

public class GoogleAuthenticator {
    public func login( email: String,
                       password: String,
                       completion: @escaping (GoogleUser?, Error?) -> Void) {
        // Make networking calls, which return a 'Token'
        let token = "special-token-value"
        let user = GoogleUser(email: email,
                              password: password,
                              token: token)
        completion(user, nil)
    }
}

public struct GoogleUser {
    public var email: String
    public var password: String
    public var token: String
}
