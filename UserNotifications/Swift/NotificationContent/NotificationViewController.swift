//
//  NotificationViewController.swift
//  NotificationContent
//
//  Created by pro648 on 18/8/18
//  Copyright © 2018年 pro648. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet var label: UILabel?
    @IBOutlet weak var speakerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
    }
    
    func didReceive(_ notification: UNNotification) {
//        self.label?.text = notification.request.content.body
        
        title = "pro648"
        self.label?.text = String("Content Extension:\(notification.request.content.body)")
        speakerLabel.shake()
    }
    
    func didReceive(_ response: UNNotificationResponse, completionHandler completion: @escaping (UNNotificationContentExtensionResponseOption) -> Void) {
        if response.actionIdentifier == "stop" {
            speakerLabel.text = "🔇"
            speakerLabel.cancelShake()
            completion(.doNotDismiss)
        } else if response.actionIdentifier == "comment" {
            completion(.dismissAndForwardAction)
        } else {
            completion(.dismiss)
        }
    }
}

extension UIView {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 1
        animation.repeatCount = .infinity
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0]
        layer.add(animation, forKey: "shake")
    }
    
    func cancelShake() {
        layer.removeAnimation(forKey: "shake")
    }
}
