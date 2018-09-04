//
//  TimeIntervalViewController.m
//  UserNotifications Objective-C
//
//  Created by pro648 on 18/8/26
//  Copyright © 2018年 pro648. All rights reserved.
//

#import "TimeIntervalViewController.h"
#import <UserNotifications/UserNotifications.h>

@interface TimeIntervalViewController ()

@property (weak, nonatomic) IBOutlet UILabel *timeIntervalLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, assign) NSUInteger time;

@end

@implementation TimeIntervalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Time Interval";
    self.descriptionLabel.text = @"You can receive notification weather your app was running in the foreground or background.";
    
    self.time = 5;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [UNUserNotificationCenter.currentNotificationCenter getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        if (settings.authorizationStatus != UNAuthorizationStatusAuthorized) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Notification was disabled"
                                                                                     message:@"Turn on your notifications." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                                   style:UIAlertActionStyleCancel
                                                                 handler:^(UIAlertAction * _Nonnull action) {
                                                                     [self.navigationController popViewControllerAnimated:YES];
                                                                 }];
            UIAlertAction *settingAction = [UIAlertAction actionWithTitle:@"Setting"
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * _Nonnull action) {
                                                                      [UIApplication.sharedApplication openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
                                                                  }];
            [alertController addAction:cancelAction];
            [alertController addAction:settingAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)stepperValueChanged:(UIStepper *)sender {
    self.time = (NSUInteger)sender.value;
    self.timeIntervalLabel.text = [NSString stringWithFormat:@"%li",(NSUInteger)sender.value];
}

- (IBAction)scheduleButtonPressed:(UIButton *)sender {
    // Create notification content.
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"Time Interval Notification";
    content.body = @"github.com/pro648";
    content.sound = UNNotificationSound.defaultSound;
    
    // Create a trigger that fires in specified amount of time.
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:self.time repeats:NO];
    
    // Create a unique identifier for this notification request.
    NSString *identifier = @"timeInterval";
    
    // The request includes the content of the notification and the trigger conditions for delivery.
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier
                                                                          content:content
                                                                          trigger:trigger];
    
    // Add the request to notification center.
    [UNUserNotificationCenter.currentNotificationCenter addNotificationRequest:request
                                                         withCompletionHandler:^(NSError * _Nullable error) {
                                                             if (error) {
                                                                 NSLog(@"Failed to schedule time interval notification. error:%@",error);
                                                             } else {
                                                                 NSLog(@"Time interval notification scheduled:%@",identifier);
                                                             }
                                                         }];
}

@end
