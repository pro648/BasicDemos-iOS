//
//  EmailFactory.swift
//  SimpleFactory
//
//  Created by pro648 on 2019/7/17.
//  Copyright © 2019 pro648. All rights reserved.
//

import Foundation

public struct EmailFactory {
    public let senderEmail: String
    
    public func createEmail(to recipient: JobApplicant) -> Email {
        let subject: String
        let messageBody: String
        
        switch recipient.status {
        case .new:
            subject = "We Received Your Application"
            messageBody = "Thanks for applying for a job here!" + "You should hear from us in 1-3 business days."
            
        case .interview:
            subject = "We Want to Interview You"
            messageBody = "Thanks for your resume,\(recipient.name)!" + "Can you come in for an interview in 30 minutes?"
            
        case .hired:
            subject = "We Want to Hire You"
            messageBody = "Congratulations, \(recipient.name)!" + "We liked your code, and you smelled nice." + "We want to offer you a position! Cha-ching! $$$"
            
        case .rejected:
            subject = "Thanks for Your Application"
            messageBody = "Thank you for applying,\(recipient.name)!" + "We have decided to move forward with other candidates." + "Please remeber to wear pants next time!"
        }
        
        return Email(subject: subject,
                     messageBody: messageBody,
                     recipientEmail: recipient.email,
                     senderEmail: senderEmail)
    }
}
