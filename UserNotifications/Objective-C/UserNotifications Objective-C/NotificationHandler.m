//
//  NotificationHandler.m
//  UserNotifications Objective-C
//
//  Created by pro648 on 18/8/26
//  Copyright © 2018年 pro648. All rights reserved.
//

#import "NotificationHandler.h"
#import <UIKit/UIKit.h>

@implementation NotificationHandler

#pragma mark - UNUserNotificationsDelegate

// If your app is in the foreground when a notification arrives, the shared user notification center calls this method to deliver the notificaiton directly to your app.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    if ([notification.request.identifier isEqualToString:@"calendar"]) {
        completionHandler(UNNotificationPresentationOptionNone);
    } else {
        completionHandler(UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
    }
    
}

// Use this method to process the user's response to a notification.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    if (response.actionIdentifier == UNNotificationDefaultActionIdentifier) {
        NSLog(@"Default Action");
    } else if (response.actionIdentifier == UNNotificationDismissActionIdentifier) {
        NSLog(@"Dismiss Action");
    } else if ([response.notification.request.content.categoryIdentifier isEqualToString:@"calendarCategory"]) {
        [self handleCalendarCategoryAction:response];
    } else if ([response.notification.request.content.categoryIdentifier isEqualToString:@"customUICategory"]) {
        [self handleCustomUICategory:response];
    }
    
    UIApplication.sharedApplication.applicationIconBadgeNumber = 0;
    completionHandler();
}

#pragma mark - Help Method

- (void)handleCalendarCategoryAction:(UNNotificationResponse *)response {
    if ([response.actionIdentifier isEqualToString:@"markAsCompleted"]) {
        return;
    } else if ([response.actionIdentifier isEqualToString:@"remindMeIn1Minute"]) {
        // 1 Minute
        NSDate *newDate = [NSDate dateWithTimeIntervalSinceNow:60];
        [self scheduleNotificationAt:newDate];
        NSLog(@"1 Minute");
    } else if ([response.actionIdentifier isEqualToString:@"remindMeIn5Minutes"]) {
        NSDate *newDate = [[NSDate alloc] initWithTimeIntervalSinceNow:60*5];
        [self scheduleNotificationAt:newDate];
        NSLog(@"5 Minutes");
    }
}

- (void)handleCustomUICategory:(UNNotificationResponse *)response {
    NSString *text = @"";
    if ([response.actionIdentifier isEqualToString:@"stop"]) {
        return;
    } else if ([response.actionIdentifier isEqualToString:@"comment"]) {
        text = ((UNTextInputNotificationResponse *)response).userText;
    }
    
    if (text.length > 0) {
        NSString *message = [NSString stringWithFormat:@"You just said:%@",text];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Comment" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:okAction];
        
        UIViewController *vc = UIApplication.sharedApplication.keyWindow.rootViewController;
        [vc presentViewController:alertController animated:YES completion:nil];
    }
    
}

// Calendar
- (void)scheduleNotificationAt:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierChinese];
    NSDateComponents *components = [calendar componentsInTimeZone:[NSTimeZone localTimeZone] fromDate:date];
    NSDateComponents *newComponents = [[NSDateComponents alloc] init];
    newComponents.calendar = calendar;
    newComponents.timeZone = [NSTimeZone localTimeZone];
    newComponents.month = components.month;
    newComponents.day = components.day;
    newComponents.hour = components.hour;
    newComponents.minute = components.minute;
    
    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:newComponents repeats:NO];
    
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"Calendar Reminder";
    content.body = @"github.com/pro648";
    content.sound = UNNotificationSound.defaultSound;
    content.categoryIdentifier = @"calendarCategory";
    
    // Request
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"calendar"
                                                                          content:content
                                                                          trigger:trigger];
    
    [UNUserNotificationCenter.currentNotificationCenter addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Failed to add request to notification center. error:\(error)");
        }
    }];
}

@end
