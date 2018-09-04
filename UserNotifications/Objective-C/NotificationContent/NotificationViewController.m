//
//  NotificationViewController.m
//  NotificationContent
//
//  Created by pro648 on 18/8/26
//  Copyright © 2018年 pro648. All rights reserved.
//

#import "NotificationViewController.h"
#import <UserNotifications/UserNotifications.h>
#import <UserNotificationsUI/UserNotificationsUI.h>

@interface NotificationViewController () <UNNotificationContentExtension>

@property IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *speakerLabel;

@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any required interface initialization here.
}

- (void)didReceiveNotification:(UNNotification *)notification {
//    self.label.text = notification.request.content.body;
    
    self.title = @"pro648";
    self.label.text = [NSString stringWithFormat:@"Content Extension:%@",notification.request.content.body];
    [self shake];
}

- (void)didReceiveNotificationResponse:(UNNotificationResponse *)response completionHandler:(void (^)(UNNotificationContentExtensionResponseOption))completion {
    if ([response.actionIdentifier isEqualToString:@"stop"]) {
        self.speakerLabel.text = @"🔇";
        [self cancelShake];
        completion(UNNotificationContentExtensionResponseOptionDoNotDismiss);
    } else if ([response.actionIdentifier isEqualToString:@"comment"]){
        completion(UNNotificationContentExtensionResponseOptionDismissAndForwardAction);
    } else {
        completion(UNNotificationContentExtensionResponseOptionDismiss);
    }
}

- (void)shake {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.duration = 1;
    animation.repeatCount = HUGE_VALF;
    animation.values = @[@(-20.0), @(20.0), @(-20.0), @(20.0), @(-10.0), @(10.0), @(-5.0), @(5.0), @(0.0)];
    [self.speakerLabel.layer addAnimation:animation forKey:@"shake"];
}

- (void)cancelShake {
    [self.speakerLabel.layer removeAnimationForKey:@"shake"];
}

@end
