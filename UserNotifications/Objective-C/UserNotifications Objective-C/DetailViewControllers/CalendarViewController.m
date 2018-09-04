//
//  CalendarViewController.m
//  UserNotifications Objective-C
//
//  Created by pro648 on 18/8/26
//  Copyright © 2018年 pro648. All rights reserved.
//

#import "CalendarViewController.h"
#import <UserNotifications/UserNotifications.h>

@interface CalendarViewController ()

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end

@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Calendar";
    self.descriptionLabel.text = @"You need to switch to background to receive the notification.";
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

- (IBAction)datePickerDidSelectNewDate:(UIDatePicker *)sender {
    NSDate *selectedDate = sender.date;
    NSLog(@"Selected date:%@",selectedDate);
    
    [self scheduleNotificationAt:selectedDate];
}

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
    
    // Configure the notificaiton's payload.
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"Calendar Reminder";
    content.subtitle = @"This is subtitle";
    content.body = @"github.com/pro648";
    content.sound = UNNotificationSound.defaultSound;
    content.badge = 0;
    content.categoryIdentifier = @"calendarCategory";
    
    // Create the request.
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"calendar"
                                                                          content:content
                                                                          trigger:trigger];
    
    // Schedule the request with the system.
    [UNUserNotificationCenter.currentNotificationCenter addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Failed to add request to notification center. error:\(error)");
        }
    }];
}

@end
