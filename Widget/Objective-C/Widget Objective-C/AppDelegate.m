//
//  AppDelegate.m
//  Widget Objective-C
//
//  Created by pro648 on 18/7/22
//  Copyright © 2018年 pro648. All rights reserved.
//

#import "AppDelegate.h"
#import "FirstVC.h"
#import "SecondVC.h"

@interface AppDelegate ()

@property (nonatomic, strong) UITabBarController *tabBarController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.tabBarController = [[UIStoryboard storyboardWithName:@"Main" bundle:NULL] instantiateViewControllerWithIdentifier:NSStringFromClass(UITabBarController.class)];
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.pro648.widget.swift"];
    if ([url.host isEqualToString:@"first"] && [url.path isEqualToString:@"/word"]) {
        self.tabBarController.selectedIndex = 0;
        FirstVC *firstVC = self.tabBarController.selectedViewController;
        firstVC.label.text = [url.query stringByRemovingPercentEncoding];
        [userDefaults setBool:YES forKey:@"first"];
        
        return YES;
    } else if ([url.host isEqualToString:@"second"] && [url.path isEqualToString:@"/word"]) {
        self.tabBarController.selectedIndex = 1;
        SecondVC *secondVC = self.tabBarController.selectedViewController;
        secondVC.label.text = [url.query stringByRemovingPercentEncoding];
        [userDefaults setBool:NO forKey:@"first"];
        
        return YES;
    } else {
        return NO;
    }
    
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


@end
