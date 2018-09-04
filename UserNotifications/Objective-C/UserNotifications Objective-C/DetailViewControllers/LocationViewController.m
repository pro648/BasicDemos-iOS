//
//  LocationViewController.m
//  UserNotifications Objective-C
//
//  Created by pro648 on 18/8/26
//  Copyright © 2018年 pro648. All rights reserved.
//

#import "LocationViewController.h"
#import <UserNotifications/UserNotifications.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationViewController () <CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *radiusLabel;
@property (weak, nonatomic) IBOutlet UILabel *locValue;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate2D;
@property (nonatomic, assign) NSUInteger radius;

@end

@implementation LocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Ask for authorisation from the user.
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager requestAlwaysAuthorization];
    
    if (CLLocationManager.locationServicesEnabled) {
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        [self.locationManager startUpdatingLocation];
    }
    
    self.title = @"Location";
    self.descriptionLabel.text = @"You can receive notification weather your app was running in the foreground or background.";
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
    self.radiusLabel.text = [NSString stringWithFormat:@"%li",(NSUInteger)sender.value];
    self.radius = (NSUInteger)sender.value;
}

- (IBAction)scheduleButtonTapped:(UIButton *)sender {
    // Content
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"Location Notification";
    content.body = @"Exit the specified region";
    
    // Creating a location-based trigger.
    CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:self.coordinate2D radius:self.radius identifier:@"Headquarters"];
    region.notifyOnExit = YES;
    region.notifyOnEntry = NO;
    UNLocationNotificationTrigger *trigger = [UNLocationNotificationTrigger triggerWithRegion:region repeats:YES];
    
    // Identifier
    NSString *identifier = @"location";
    
    // Request
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier
                                                                          content:content
                                                                          trigger:trigger];
    
    // Schedule
    [UNUserNotificationCenter.currentNotificationCenter addNotificationRequest:request
                                                         withCompletionHandler:^(NSError * _Nullable error) {
                                                             if (error) {
                                                                 NSLog(@"Failed to schedule location notification. error:%@",error);
                                                             } else {
                                                                 NSLog(@"Location notification scheduled:%@",identifier);
                                                             }
                                                         }];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *location = locations.lastObject;
    if (location.horizontalAccuracy > 0) {
        [self.locationManager stopUpdatingLocation];
        
        self.coordinate2D = location.coordinate;
        self.locValue.text = [NSString stringWithFormat:@"Latitude:%f Longitude:%f",location.coordinate.latitude, location.coordinate.longitude];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Failed to get current location. error:%@",error);
}

@end
