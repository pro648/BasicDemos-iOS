//
//  SecondViewController.m
//  UIKitDynamics
//
//  Created by ad on 22/06/2017.
//
//  详细博文：https://github.com/pro648/tips/wiki/%E4%B8%80%E7%AF%87%E6%96%87%E7%AB%A0%E5%AD%A6%E4%BC%9A%E4%BD%BF%E7%94%A8UIKit%20Dynamics

#import "SecondViewController.h"

@interface SecondViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UIView *menuView;
@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) UITableView *menuTable;
@property (strong, nonatomic) UIDynamicAnimator *animator;

@end

#define menuWidth self.view.frame.size.width/2
static NSString * const reuseIdentifier = @"CellIdentifier";

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加背景视图 菜单视图 表视图
    [self.view addSubview:self.backgroundView];
    [self.view addSubview:self.menuView];
    [self.menuView addSubview:self.menuTable];

    // 注册cell
    [self.menuTable registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseIdentifier];
    
    // 添加右滑手势
    UISwipeGestureRecognizer *showMenuGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    showMenuGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:showMenuGesture];
    
    // 添加左滑手势
    UISwipeGestureRecognizer *hideMenuGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    hideMenuGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.menuView addGestureRecognizer:hideMenuGesture];
    
    // view添加左滑手势
    UISwipeGestureRecognizer *hideMenuGestureView = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    hideMenuGestureView.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:hideMenuGestureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Properties

// 1.设置背景视图
- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] initWithFrame:self.view.frame];
        _backgroundView.backgroundColor = [UIColor lightGrayColor];
        _backgroundView.alpha = 0.0;
    }
    return _backgroundView;
}

// 2.设置菜单视图
- (UIView *)menuView {
    if (!_menuView) {
        _menuView = [[UIView alloc] initWithFrame:CGRectMake(-menuWidth, 20, menuWidth, self.view.frame.size.height - self.tabBarController.tabBar.frame.size.height)];
        _menuView.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
    }
    return _menuView;
}

// 3.设置表视图
- (UITableView *)menuTable {
    if (!_menuTable) {
        _menuTable = [[UITableView alloc] initWithFrame:self.menuView.bounds style:UITableViewStylePlain];
        _menuTable.backgroundColor = [UIColor clearColor];
        _menuTable.alpha = 1.0;
        _menuTable.scrollEnabled = NO;
        _menuTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _menuTable.delegate = self;
        _menuTable.dataSource = self;
    }
    return _menuTable;
}

// 4.初始化UIDynamicAnimator
- (UIDynamicAnimator *)animator {
    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    }
    return _animator;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];

    cell.textLabel.text = [NSString stringWithFormat:@"Option %li",indexPath.row + 1];
    cell.textLabel.textColor = [UIColor lightGrayColor];
    cell.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO];
}

#pragma mark - Help Method

- (void)toggleMenu:(BOOL)shouldOpenMenu {
    // 移除所有动力行为
    [self.animator removeAllBehaviors];
    
    // 根据参数shouldOpenMenu 获取重力方向 推力方向 边界位置
    CGFloat gravityDirectionX = shouldOpenMenu ? 1.0 : -1.0;
    CGFloat pushMagnitude = shouldOpenMenu ? 20.0 : -20.0;
    CGFloat boundaryPointX = shouldOpenMenu ? menuWidth : -menuWidth;
    
    // 添加重力行为
    UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[self.menuView]];
    gravityBehavior.gravityDirection = CGVectorMake(gravityDirectionX, 0);
    [self.animator addBehavior:gravityBehavior];
    
    // 添加碰撞行为
    UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.menuView]];
    [collisionBehavior addBoundaryWithIdentifier:@"menuBoundary" fromPoint:CGPointMake(boundaryPointX, 20) toPoint:CGPointMake(boundaryPointX, self.tabBarController.tabBar.frame.origin.y)];
    [self.animator addBehavior:collisionBehavior];
    
    // 添加推力行为
    UIPushBehavior *pushBehavior = [[UIPushBehavior alloc] initWithItems:@[self.menuView] mode:UIPushBehaviorModeInstantaneous];
    pushBehavior.magnitude = pushMagnitude;
    [self.animator addBehavior:pushBehavior];
    
    // 设置menuView的elasticity属性
    UIDynamicItemBehavior *menuViewBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.menuView]];
    menuViewBehavior.elasticity = 0.4;
    [self.animator addBehavior:menuViewBehavior];
        
    // 设置backgroundView alpha值
    self.backgroundView.alpha = shouldOpenMenu ? 0.5 : 0;
}

- (void)handleGesture:(UISwipeGestureRecognizer *)gesture {
    if (gesture.direction == UISwipeGestureRecognizerDirectionRight) {
        [self toggleMenu:YES];
    } else {
        [self toggleMenu:NO];
    }
}

@end
