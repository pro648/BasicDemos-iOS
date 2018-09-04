//
//  NotificationHandler.swift
//  UserNotification Swift
//
//  Created by pro648 on 18/8/18
//  Copyright © 2018年 pro648. All rights reserved.
//

import UIKit
import UserNotifications

enum UserNotificationType: String {
    case calendar
    case timeInterval
    case location
    case customUI
}

extension UserNotificationType {
    var descriptionText: String {
        switch self {
        case .calendar:
            return "You need to switch to background to receive the notification."
            
        case .timeInterval:
            return "You can receive notification weather your app was running in the foreground or background."
            
        case .location:
            return "You can receive notification weather your app was running in the foreground or background."
            
        default:
            return rawValue
        }
    }
    
    var title: String {
        switch self {
        case .calendar:
            return "Calendar"
            
        case .timeInterval:
            return "TimeInterval"
            
        case .location:
            return "Location"
            
        default:
            return rawValue
        }
    }
}

enum UserNotificationCategoryType: String {
    case calendarCategory
    case customUICategory
}

enum CalendarCategoryAction: String {
    case markAsCompleted
    case remindMeIn1Minute
    case remindMeIn5Minutes
}

enum CustomizeUICategoryAction: String {
    case stop
    case comment
}

class NotificationHandler: NSObject, UNUserNotificationCenterDelegate {
    
    // If your app is in the foreground when a notification arrives, the shared user notification center calls this method to deliver the notificaiton directly to your app.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        guard let notificationType = UserNotificationType(rawValue: notification.request.identifier) else {
            completionHandler([])
            return
        }

        let options: UNNotificationPresentationOptions

        switch notificationType {
        case .calendar:
            options = []
        default:
            options = [.alert, .sound]
        }

        completionHandler(options)
    }
    
    // Use this method to process the user's response to a notification.
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

        if response.actionIdentifier == UNNotificationDefaultActionIdentifier {
            print("Default Action")
        } else if (response.actionIdentifier == UNNotificationDismissActionIdentifier){
            print("Dismiss action")
        }else if let category = UserNotificationCategoryType(rawValue: response.notification.request.content.categoryIdentifier) {
            switch category {
            case .calendarCategory:
                handleCalendarCategory(response: response)
            case .customUICategory:
                handleCustomUICategory(response: response)
            }
        }

        UIApplication.shared.applicationIconBadgeNumber = 0

        completionHandler()
    }

    private func handleCalendarCategory(response: UNNotificationResponse) {
        if let actionType = CalendarCategoryAction(rawValue: response.actionIdentifier) {
            switch actionType {
            case .markAsCompleted:
                break

            case .remindMeIn1Minute:
                // 1 Minute
                let newDate = Date(timeInterval: 60, since: Date())
                scheduleNotification(at: newDate)
                print("1 Minute")

            case .remindMeIn5Minutes:
                // 5 Minutes
                let newDate = Date(timeInterval: 60*5, since: Date())
                scheduleNotification(at: newDate)
                print("5 Minutes")
            }
        }
    }
    
    private func handleCustomUICategory(response: UNNotificationResponse) {
        var text: String = ""
        
        
        if let actionType = CustomizeUICategoryAction(rawValue: response.actionIdentifier) {
            switch actionType {
            case .stop:
                break;
                
            case .comment:
                text = (response as! UNTextInputNotificationResponse).userText
            }
        }
        
        if !text.isEmpty {
            let alertController = UIAlertController(title: "Comment", message: "You just said:\(text)", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(okAction)
            
            let viewController = UIApplication.shared.keyWindow?.rootViewController
            viewController?.present(alertController, animated: true, completion: nil)
        }
        
        print(response.actionIdentifier)
    }
    
    
    
    // calendar
    func scheduleNotification(at date: Date) {
        let calendar = Calendar(identifier: .chinese)
        let components = calendar.dateComponents(in: .current, from: date)
        let newComponents = DateComponents(calendar: calendar, timeZone: .current, month: components.month, day: components.day, hour: components.hour, minute: components.minute)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: newComponents, repeats: false)
        
        let content = UNMutableNotificationContent()
        content.title = "Calendar Reminder"
        content.body = "github.com/pro648"
        content.sound = UNNotificationSound.default()
        content.categoryIdentifier = UserNotificationCategoryType.calendarCategory.rawValue
        
        // request
        let request = UNNotificationRequest(identifier: UserNotificationType.calendar.rawValue, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Failed to add request to notification center. error:\(error)")
            }
        }
    }
}
