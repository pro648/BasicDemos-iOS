//
//  FifthViewController.m
//  UIKitDynamics
//
//  Created by ad on 22/06/2017.
//
//  详细博文：https://github.com/pro648/tips/wiki/%E4%B8%80%E7%AF%87%E6%96%87%E7%AB%A0%E5%AD%A6%E4%BC%9A%E4%BD%BF%E7%94%A8UIKit%20Dynamics

#import "FifthViewController.h"

@interface FifthViewController ()

@property (strong, nonatomic) UIView *blueView;
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) UIFieldBehavior *radialGravityField;
@property (strong, nonatomic) UIFieldBehavior *vortexField;

@end

@implementation FifthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.blueView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // 1.开启调试模式
    [self.animator setValue:[NSNumber numberWithBool:YES] forKey:@"debugEnabled"];
    
    // 2.配置动力项密度
    UIDynamicItemBehavior *blueViewBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.blueView]];
    blueViewBehavior.density = 0.5;
    [self.animator addBehavior:blueViewBehavior];
    
    // 3.添加动力项到动力行为
    [self.vortexField addItem:self.blueView];
    [self.radialGravityField addItem:self.blueView];
    
    // 4.添加动力行为到animator
    [self.animator addBehavior:self.vortexField];
    [self.animator addBehavior:self.radialGravityField];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Properties

- (UIView *)blueView {
    if (!_blueView) {
        _blueView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        _blueView.center = CGPointMake(self.view.center.x*2/3, self.view.center.y*2/3);
        _blueView.layer.cornerRadius = _blueView.frame.size.width/2;
        _blueView.layer.backgroundColor = [UIColor blueColor].CGColor;
    }
    return _blueView;
}

- (UIDynamicAnimator *)animator {
    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    }
    return _animator;
}

- (UIFieldBehavior *)radialGravityField {
    if (!_radialGravityField) {
        // 1.使用类方法初始化radialGravityField
        _radialGravityField = [UIFieldBehavior radialGravityFieldWithPosition:self.view.center];
        // 2.指定radialGravityField区域
        _radialGravityField.region = [[UIRegion alloc] initWithRadius:300];
        // 3.设置场强
        _radialGravityField.strength = 1.5;
        // 4.场强随距离变化
        _radialGravityField.falloff = 4.0;
        // 5.场强变化的最小半径
        _radialGravityField.minimumRadius = 50.0;
    }
    return _radialGravityField;
}

- (UIFieldBehavior *)vortexField {
    if (!_vortexField) {
        // 1.初始化vortexField
        _vortexField = [UIFieldBehavior vortexField];
        // 2.设置position为视图中心
        _vortexField.position = self.view.center;
        
        _vortexField.region = [[UIRegion alloc] initWithRadius:200];
        _vortexField.strength = 0.005;
    }
    return _vortexField;
}

@end


























