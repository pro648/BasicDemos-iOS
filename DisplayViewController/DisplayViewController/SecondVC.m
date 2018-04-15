//
//  SecondVC.m
//  DisplayViewController
//
//  Created by pro648 on 14/04/2018.
//  Copyright © 2018 pro648. All rights reserved.
//

#import "SecondVC.h"
#import "FirstVC.h"

@interface SecondVC ()

@end

@implementation SecondVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置背景颜色。
    self.view.backgroundColor = self.color;
    
    // 添加退出当前视图控制器按钮。
    UIButton *dismissVCButton = [UIButton buttonWithType:UIButtonTypeSystem];
    dismissVCButton.frame = CGRectMake(0, 0, self.view.bounds.size.width, 30);
    dismissVCButton.center = self.view.center;
    [dismissVCButton setTitle:@"dismissViewControllerAnimated:completion:" forState:UIControlStateNormal];
    [dismissVCButton addTarget:self action:@selector(dismissVCButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dismissVCButton];
    
    // 添加弹出当前堆栈视图控制器顶部控制器按钮。
    UIButton *popVCButton = [UIButton buttonWithType:UIButtonTypeSystem];
    popVCButton.frame = CGRectMake(0, 0, self.view.bounds.size.width, 30);
    popVCButton.center = CGPointMake(self.view.center.x, self.view.center.y + 50);
    [popVCButton setTitle:@"popViewControllerAnimated:" forState:UIControlStateNormal];
    [popVCButton addTarget:self action:@selector(popVCButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:popVCButton];
    
    NSLog(@"%lu",self.popoverPresentationController.arrowDirection);
    
    if (self.popoverPresentationController.arrowDirection == UIPopoverArrowDirectionDown) {
        NSLog(@"down");
    }
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSLog(@"SecondVC did appear");
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    NSLog(@"SecondVC did disappear");
}

- (void)dismissVCButtonClicked:(UIButton *)sender {
    // 退出当前控制器。
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"Dismiss SecondVC Completion");
    }];
}

- (void)popVCButtonClicked:(UIButton *)sender {
    // 弹出顶部视图控制器。
    [self.navigationController popViewControllerAnimated:YES];
}

@end
