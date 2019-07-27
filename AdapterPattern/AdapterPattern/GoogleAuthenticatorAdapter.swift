//
//  GoogleAuthenticatorAdapter.swift
//  AdapterPattern
//
//  Created by pro648 on 2019/7/25.
//  Copyright © 2019 pro648. All rights reserved.
//

import Foundation

public class GoogleAuthenticatorAdapter: AuthenticationService {
    private var authenticator = GoogleAuthenticator()
    
    public func login(email: String, password: String, success: @escaping (User, Token) -> Void, failure: @escaping (Error?) -> Void) {
        authenticator.login(email: email, password: password) { (googleUser, error) in
            guard let googleUser = googleUser else {
                failure(error)
                return
            }
            
            let user = User(email: googleUser.email, password: googleUser.password)
            let token = Token(value: googleUser.token)
            success(user, token)
        }
    }
}
