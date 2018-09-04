//
//  CalendarViewController.swift
//  UserNotification Swift
//
//  Created by pro648 on 18/8/18
//  Copyright © 2018年 pro648. All rights reserved.
//

import UIKit
import UserNotifications

class CalendarViewController: UIViewController {
    
    var notificationType: UserNotificationType!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
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
    
    @IBAction func datePickerDidSelectNewDate(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        print("Selected date:\(selectedDate)")
        
        scheduleNotification(at: selectedDate)
    }
    
    func scheduleNotification(at date: Date) {
        let calendar = Calendar(identifier: .chinese)
        let components = calendar.dateComponents(in: .current, from: date)
        let newComponents = DateComponents(calendar: calendar, timeZone: .current, month: components.month, day: components.day, hour: components.hour, minute: components.minute)

        let trigger = UNCalendarNotificationTrigger(dateMatching: newComponents, repeats: false)
        
        // Configure the notificaiton's payload.
        let content = UNMutableNotificationContent()
        content.title = "Calendar Title"
        content.title = NSString.localizedUserNotificationString(forKey: "Calendar Title", arguments: nil)
        content.subtitle = "This is subtitle"
        content.body = "github.com/pro648"
        content.sound = UNNotificationSound.default()
        content.badge = 0
        content.categoryIdentifier = UserNotificationCategoryType.calendarCategory.rawValue
        
        // Create the request.
        let request = UNNotificationRequest(identifier: UserNotificationType.calendar.rawValue, content: content, trigger: trigger)
        
        // Schedule the request with the system.
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Failed to add request to notification center. error:\(error)")
            }
        }
    }
}
