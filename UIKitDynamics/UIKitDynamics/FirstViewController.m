//
//  FirstViewController.m
//  UIKitDynamics
//
//  Created by ad on 22/06/2017.
//
//  详细博文：https://github.com/pro648/tips/wiki/%E4%B8%80%E7%AF%87%E6%96%87%E7%AB%A0%E5%AD%A6%E4%BC%9A%E4%BD%BF%E7%94%A8UIKit%20Dynamics

#import "FirstViewController.h"

@interface FirstViewController ()

@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) UIView *orangeBall;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1.初始化、配置orangeBall
    self.orangeBall = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2-25, 100, 50, 50)];
    self.orangeBall.backgroundColor = [UIColor orangeColor];
    self.orangeBall.layer.cornerRadius = 25;
    [self.view addSubview:self.orangeBall];
    
    // 2.初始化animator
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    // 调用testGravity方法
    [self testGravity];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)testGravity {
    // 1.初始化重力行为
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:@[self.orangeBall]];
    gravity.action = ^{
        NSLog(@"%f",self.orangeBall.center.y);
    };
    
    // 2.添加重力行为到UIDynamicAnimator
    [self.animator addBehavior:gravity];
    
    // 3.初始化碰撞行为、制定边界
    UICollisionBehavior *collision = [[UICollisionBehavior alloc] initWithItems:@[self.orangeBall]];
    [collision addBoundaryWithIdentifier:@"tabbar" fromPoint:self.tabBarController.tabBar.frame.origin toPoint:CGPointMake(self.tabBarController.tabBar.frame.origin.x + self.tabBarController.tabBar.frame.size.width, self.tabBarController.tabBar.frame.origin.y)];
    [self.animator addBehavior:collision];
    
    // 4.初始化UIDynamicItemBehavior 修改elasticity
    UIDynamicItemBehavior *ballBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.orangeBall]];
    ballBehavior.elasticity = 0.7;
    [self.animator addBehavior:ballBehavior];
}

@end
