//
//  TabBarController.m
//  UIKitDynamics
//
//  Created by ad on 22/06/2017.
//
//  详细博文：https://github.com/pro648/tips/wiki/%E4%B8%80%E7%AF%87%E6%96%87%E7%AB%A0%E5%AD%A6%E4%BC%9A%E4%BD%BF%E7%94%A8UIKit%20Dynamics

#import "TabBarController.h"

// 导入视图控制器
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "FourthViewController.h"
#import "FifthViewController.h"

@interface TabBarController ()

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化视图控制器 设定标题 tabBarItem图片
    UIImage *image = [UIImage imageNamed:@"circle"];
    FirstViewController *firstVC = [[FirstViewController alloc] init];
    firstVC.title = @"First";
    firstVC.tabBarItem.image = image;
    
    SecondViewController *secVC = [[SecondViewController alloc] init];
    secVC.title = @"Second";
    secVC.tabBarItem.image = image;
    
    ThirdViewController *thirdVC = [[ThirdViewController alloc] init];
    thirdVC.title = @"Third";
    thirdVC.tabBarItem.image = image;
    
    FourthViewController *fourthVC = [[FourthViewController alloc] init];
    fourthVC.title = @"Fourth";
    fourthVC.tabBarItem.image = image;
    
    FifthViewController *fifthVC = [[FifthViewController alloc] init];
    fifthVC.title = @"Fifth";
    fifthVC.tabBarItem.image = image;
    
    // 设置标签栏控制器的根视图
    [self setViewControllers:@[firstVC, secVC, thirdVC, fourthVC, fifthVC] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
