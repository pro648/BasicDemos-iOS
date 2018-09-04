//
//  AppDelegate.swift
//  UserNotification Swift
//
//  Created by pro648 on 18/8/18
//  Copyright © 2018年 pro648. All rights reserved.
//  详细介绍：https://github.com/pro648/tips/wiki/UserNotifications%E6%A1%86%E6%9E%B6%E8%AF%A6%E8%A7%A3

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let notificationHandler = NotificationHandler()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Request notifications authorization.
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound, .carPlay]) { (granted, error) in
            print("Permission granted:\(granted)")
            guard granted else { return }
            
            // Register for push notification.
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
        
        registerNotificationCategory()
        
        // You must assign your delegate object to the UNUserNotificaitonCenter object before your app finishes launching.
        UNUserNotificationCenter.current().delegate = notificationHandler
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Receive device token
        let token = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }.joined()
        print("Device Token:\(token)")
        
        // Forward token to server.
        // Enable remote notification features.
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Fail to register for remote notifications. error:\(error)")
        
        // Disable remote notification features.
        
        // 如果没有在apple developer 注册 提示：Fail to register for remote notifications. error:Error Domain=NSCocoaErrorDomain Code=3000 "未找到应用程序的“aps-environment”的授权字符串" UserInfo={NSLocalizedDescription=未找到应用程序的“aps-environment”的授权字符串}
    }
    
    private func registerNotificationCategory() {
        // calendarCategory
        let completeAction = UNNotificationAction(identifier: CalendarCategoryAction.markAsCompleted.rawValue,
                                                  title: "Mark as Completed",
                                                  options: [])
        let remindMeIn1MinuteAction = UNNotificationAction(identifier: CalendarCategoryAction.remindMeIn1Minute.rawValue,
                                                           title: "Remind me in 1 Minute",
                                                           options: [])
        let remindMeIn5MinutesAction = UNNotificationAction(identifier: CalendarCategoryAction.remindMeIn5Minutes.rawValue,
                                                            title: "Remind me in 5 Minutes",
                                                            options: [])

        let calendarCategory = UNNotificationCategory(identifier: UserNotificationCategoryType.calendarCategory.rawValue,
                                                      actions: [completeAction, remindMeIn5MinutesAction, remindMeIn1MinuteAction],
                                                      intentIdentifiers: [],
                                                      options: [.customDismissAction])

        // customUICategory
        let nextAction = UNNotificationAction(identifier: CustomizeUICategoryAction.stop.rawValue,
                                              title: "Stop",
                                              options: [.foreground])
        let commentAction = UNTextInputNotificationAction(identifier: CustomizeUICategoryAction.comment.rawValue,
                                                          title: "Comment",
                                                          options: [.foreground],
                                                          textInputButtonTitle: "Send",
                                                          textInputPlaceholder: "Say something")
        let customUICategory = UNNotificationCategory(identifier: UserNotificationCategoryType.customUICategory.rawValue,
                                                      actions: [nextAction, commentAction],
                                                      intentIdentifiers: [],
                                                      options: [.customDismissAction])

        UNUserNotificationCenter.current().setNotificationCategories([calendarCategory, customUICategory])
        
        
    }
}

