//
//  FirstVC.m
//  DisplayViewController
//
//  Created by pro648 on 14/04/2018.
//  Copyright © 2018 pro648. All rights reserved.
//

#import "FirstVC.h"
#import "SecondVC.h"

@interface FirstVC ()

@end

@implementation FirstVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化showVCButton。
    UIButton *showVCButton = [UIButton buttonWithType:UIButtonTypeSystem];
    showVCButton.frame = CGRectMake(0, 0, self.view.bounds.size.width, 30);
    showVCButton.center = self.view.center;
    [showVCButton setTitle:@"showViewController:sender:" forState:UIControlStateNormal];
    [showVCButton addTarget:self action:@selector(showVCButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showVCButton];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"FirstVC did appear");
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"FirstVC did disappear");
}

- (void)showVCButtonClicked:(UIButton *)sender {
    // 初始化presented view controller。
    SecondVC *secVC = [[SecondVC alloc] init];
    secVC.color = [UIColor lightGrayColor];
    
    // show presented view controller.
//    [self showViewController:secVC sender:sender];    // 自适应呈现。
//    [self.navigationController showViewController:secVC sender:sender];   // 在堆栈中压入视图控制器，如果没有堆栈视图，则不执行操作。
//    [self.navigationController pushViewController:secVC animated:YES];      // 在堆栈中压入视图控制器，如果没有堆栈视图，则不执行操作。
    
    // 设置modalPresentationStyle、大小。
    secVC.modalPresentationStyle = UIModalPresentationPopover;
    secVC.preferredContentSize = CGSizeMake(self.view.bounds.size.height/3, self.view.bounds.size.width/2);
    
    UIPopoverPresentationController *popoverVC = secVC.popoverPresentationController;
    if (popoverVC) {
        // 设置sourceView为点击的按钮，sourceRect为按钮边框，arrow方向为上。
        popoverVC.sourceView = sender;
        popoverVC.sourceRect = sender.bounds;
        popoverVC.permittedArrowDirections = UIPopoverArrowDirectionUp;
    }
    
    [self presentViewController:secVC animated:YES completion:^{
        NSLog(@"Present sevVC completion");
    }];
}

@end
