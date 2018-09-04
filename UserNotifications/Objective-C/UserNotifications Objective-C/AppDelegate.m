//
//  AppDelegate.m
//  UserNotifications Objective-C
//
//  Created by pro648 on 18/8/26
//  Copyright © 2018年 pro648. All rights reserved.
//  详细介绍：https://github.com/pro648/tips/wiki/UserNotifications%E6%A1%86%E6%9E%B6%E8%AF%A6%E8%A7%A3

#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>
#import "NotificationHandler.h"

@interface AppDelegate ()

@property (nonatomic, strong) NotificationHandler *notificationHandler;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // Request notifications authorization.
    UNUserNotificationCenter *center = UNUserNotificationCenter.currentNotificationCenter;
    [center requestAuthorizationWithOptions:UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionCarPlay completionHandler:^(BOOL granted, NSError * _Nullable error) {
        NSLog(@"Permision granted:%@",granted ? @"YES" : @"NO");
        
        // Register for push notification.
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication.sharedApplication registerForRemoteNotifications];
        });
    }];
    
    [self registerNotificationCategory];
    
    // You must assign your delegate object to the UNUserNotificaitonCenter object before your app finishes launching.
    self.notificationHandler = [[NotificationHandler alloc] init];
    UNUserNotificationCenter.currentNotificationCenter.delegate = self.notificationHandler;
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Receive device token.
    const char *data = [deviceToken bytes];
    NSMutableString *token = [NSMutableString string];
    
    for (int i=0; i<deviceToken.length; ++i) {
        [token appendFormat:@"%02.2hhX",data[i]];
    }
    NSLog(@"Device Token: %@",[token copy]);
    
    // Forward token to server.
    // Enable remote notification features.
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(nonnull NSError *)error {
    NSLog(@"Fail to register for remote notifications. error:%@",error);
    
    // Disable remote notification features.
}

- (void)registerNotificationCategory {
    // calendarCategory
    UNNotificationAction *completeAction = [UNNotificationAction actionWithIdentifier:@"markAsCompleted"
                                                                                title:@"Mark as Completed"
                                                                              options:UNNotificationActionOptionNone];
    UNNotificationAction *remindMeIn1MinuteAction = [UNNotificationAction actionWithIdentifier:@"remindMeIn1Minute"
                                                                                         title:@"Remind me in 1 Minute"
                                                                                       options:UNNotificationActionOptionNone];
    UNNotificationAction *remindMeIn5MinuteAction = [UNNotificationAction actionWithIdentifier:@"remindMeIn5Minute"
                                                                                         title:@"Remind me in 5 Minutes"
                                                                                       options:UNNotificationActionOptionNone];
    UNNotificationCategory *calendarCategory = [UNNotificationCategory categoryWithIdentifier:@"calendarCategory"
                                                                                      actions:@[completeAction, remindMeIn1MinuteAction, remindMeIn5MinuteAction]
                                                                            intentIdentifiers:@[]
                                                                                      options:UNNotificationCategoryOptionCustomDismissAction];
    
    // customUICategory
    UNNotificationAction *nextAction = [UNNotificationAction actionWithIdentifier:@"stop"
                                                                            title:@"Stop"
                                                                          options:UNNotificationActionOptionForeground];
    UNNotificationAction *commentAction = [UNTextInputNotificationAction actionWithIdentifier:@"comment"
                                                                                        title:@"Comment"
                                                                                      options:UNNotificationActionOptionForeground
                                                                         textInputButtonTitle:@"Send"
                                                                         textInputPlaceholder:@"Say something"];
    UNNotificationCategory *customUICategory = [UNNotificationCategory categoryWithIdentifier:@"customUICategory"
                                                                                      actions:@[nextAction, commentAction]
                                                                            intentIdentifiers:@[]
                                                                                      options:UNNotificationCategoryOptionCustomDismissAction];
    
    [UNUserNotificationCenter.currentNotificationCenter setNotificationCategories:[NSSet setWithObjects:calendarCategory, customUICategory, nil]];
}

@end
