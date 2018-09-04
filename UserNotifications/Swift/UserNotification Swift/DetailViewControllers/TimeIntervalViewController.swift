//
//  TimeIntervalViewController.swift
//  UserNotification Swift
//
//  Created by pro648 on 18/8/18
//  Copyright © 2018年 pro648. All rights reserved.
//

import UIKit
import UserNotifications

class TimeIntervalViewController: UIViewController {
    
    var notificationType: UserNotificationType!
    
    @IBOutlet weak var timeIntervalLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    var time: Int = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = notificationType.title
        descriptionLabel.text = notificationType.descriptionText
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            if settings.authorizationStatus != .authorized {
                let alertController = UIAlertController(title: "Notification was disabled", message: "Turn on your notifications.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                    self.navigationController?.popViewController(animated: true)
                }))
                alertController.addAction(UIAlertAction(title: "Setting", style: .default, handler: { (action) in
                    UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
                }))
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        time = Int(sender.value)
        timeIntervalLabel.text = String(format: "%i", Int(sender.value))
    }
    
    @IBAction func scheduleButtonPressed(_ sender: UIButton) {
        // Create notificaiton content.
        let content = UNMutableNotificationContent()
        content.title = "Time Interval Notification"
        content.body = "github.com/pro648"
        content.sound = UNNotificationSound.default()
        
        // Creating a trigger that fires in specified amount of time.
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(time), repeats: false)
        
        // Create a unique identifier for this notification request.
        let identifier = notificationType.rawValue
        
        // The request includes the content of the notification and the trigger conditions for delivery.
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        // Add the request to notification center.
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Failed to schedule time interval notification. error:\(error)")
            } else {
                print("Time interval notification scheduled:\(identifier)")
            }
        }
    }
}
