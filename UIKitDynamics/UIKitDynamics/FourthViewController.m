//
//  FourthViewController.m
//  UIKitDynamics
//
//  Created by ad on 22/06/2017.
//
//  详细博文：https://github.com/pro648/tips/wiki/%E4%B8%80%E7%AF%87%E6%96%87%E7%AB%A0%E5%AD%A6%E4%BC%9A%E4%BD%BF%E7%94%A8UIKit%20Dynamics

#import "FourthViewController.h"

@interface FourthViewController ()

@property (strong, nonatomic) UIView *purpleView;
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) UISnapBehavior *snapBehavior;

@end

@implementation FourthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.purpleView];
    
    // 添加点击手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Properties

- (UIView *)purpleView {
    if (!_purpleView) {
        _purpleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        _purpleView.center = self.view.center;
        _purpleView.backgroundColor = [UIColor purpleColor];
    }
    return _purpleView;
}

- (UIDynamicAnimator *)animator {
    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    }
    return _animator;
}

#pragma mark - IBAction

- (void)handleTapGesture:(UITapGestureRecognizer *)tapGesture {
    // 1.获得点击屏幕位置
    CGPoint touchPoint = [tapGesture locationInView:self.view];
    
    // 2.snapBehavior存在时 移除
    if (self.snapBehavior) {
        [self.animator removeBehavior:self.snapBehavior];
    }
    
    // 3.初始化snapBehavior 设定damping值
    self.snapBehavior = [[UISnapBehavior alloc] initWithItem:self.purpleView snapToPoint:touchPoint];
    self.snapBehavior.damping = 0.3;
    [self.animator addBehavior:self.snapBehavior];
}

@end
