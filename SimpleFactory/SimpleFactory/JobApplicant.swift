//
//  JobApplicant.swift
//  SimpleFactory
//
//  Created by pro648 on 2019/7/17.
//  Copyright © 2019 pro648. All rights reserved.
//

import Foundation

public struct JobApplicant {
    
    public let name: String
    public let email: String
    public var status: Status
    
    public enum Status {
        case new
        case interview
        case hired
        case rejected
    }
}
