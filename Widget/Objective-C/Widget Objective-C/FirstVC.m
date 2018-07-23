//
//  FirstVC.m
//  Widget Objective-C
//
//  Created by pro648 on 18/7/22
//  Copyright © 2018年 pro648. All rights reserved.
//

#import "FirstVC.h"
#import <NotificationCenter/NotificationCenter.h>

@interface FirstVC ()

@end

@implementation FirstVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)handleButtonTapped:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"Show Widget"]) {
        [[NCWidgetController widgetController] setHasContent:YES forWidgetWithBundleIdentifier:@"i.Widget-Objective-C.UsedSpaceWidget"];
        [sender setTitle:@"Hide Widget" forState:UIControlStateNormal];
    } else {
        [[NCWidgetController widgetController] setHasContent:NO forWidgetWithBundleIdentifier:@"i.Widget-Objective-C.UsedSpaceWidget"];
        [sender setTitle:@"Show Widget" forState:UIControlStateNormal];
    }
}

@end
