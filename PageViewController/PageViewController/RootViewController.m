//
//  RootViewController.m
//  PageViewController
//
//  Created by pro648 on 2018/6/2.
//  Copyright © 2018 pro648. All rights reserved.
//

#import "RootViewController.h"
#import "DataViewController.h"
#import "Model.h"

@interface RootViewController () <UIPageViewControllerDelegate>

@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) Model *model;
@property (nonatomic, assign) NSUInteger currentIndex;
@property (nonatomic, assign) NSUInteger nextIndex;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化并配置pageViewController。
//    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
//                                                          navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
//                                                                            options:@{UIPageViewControllerOptionInterPageSpacingKey : @20}];
    
    // page curl
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl
                                                              navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                            options:@{UIPageViewControllerOptionSpineLocationKey : @(UIPageViewControllerSpineLocationMin)}];
    
    DataViewController *dataVC = [self.model viewControllerAtIndex:0];
    [self.pageViewController setViewControllers:@[dataVC]
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:YES
                                     completion:nil];
    
    // 设置代理。
    self.pageViewController.dataSource = self.model;
    self.pageViewController.delegate = self;
    
    // 设置pageViewController inset。
    CGRect pageViewRect = self.view.bounds;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        pageViewRect = CGRectInset(pageViewRect, 40, 40);
    }
    self.pageViewController.view.frame = pageViewRect;
    
    // 添加视图控制器、视图。
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    
    [self.pageViewController didMoveToParentViewController:self];
    
    // 设置page indicator颜色。
    UIPageControl *pagecontrol = UIPageControl.appearance;
    pagecontrol.pageIndicatorTintColor = [UIColor lightGrayColor];
    pagecontrol.currentPageIndicatorTintColor = [UIColor darkGrayColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIPageViewControllerDelegate

// 手势导航开始前调用该方法。
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers {
    // 如果用户终止了滑动导航，transition将不能完成，页面也将保持不变。
    
    DataViewController *dataVC = (DataViewController *)pendingViewControllers.firstObject;
    if (dataVC) {
        self.nextIndex = dataVC.itemIndex;
        
        // 输出滑动方向
        if (self.currentIndex < self.nextIndex) {
            NSLog(@"Forward");
        } else {
            NSLog(@"Backward");
        }
    }
}

// 手势导航结束后调用该方法。
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    // 使用completed参数区分成功导航和中止导航。
    if (completed) {
        self.currentIndex = self.nextIndex;
    }
}

- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation {
    if (UIInterfaceOrientationIsPortrait(orientation) || ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)) {
        // 设备为phone，或portrait状态时，设置UIPageViewControllerSpineLocation为Min。

        DataViewController *currentVC = self.pageViewController.viewControllers.firstObject;
        [self.pageViewController setViewControllers:@[currentVC]
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:YES
                                         completion:nil];
        self.pageViewController.doubleSided = NO;
        return UIPageViewControllerSpineLocationMin;
    } else {
        // 在landscape orientation时，设置spine为mid，pageViewController展示两个视图控制器。

        DataViewController *currentVC = self.pageViewController.viewControllers.firstObject;
        NSUInteger indexOfCurrentVC = currentVC.itemIndex;

        NSArray *viewControllers = [NSArray array];

        if (indexOfCurrentVC == 0 || indexOfCurrentVC % 2 == 0) {
            // 如果当前页为偶数，则显示当前页和下一页。
            UIViewController *nextVC = [self.model pageViewController:self.pageViewController viewControllerAfterViewController:currentVC];
            viewControllers = @[currentVC, nextVC];
        } else {
            // 如果当前页为奇数，则显示上一页和当前页。
            UIViewController *previousVC = [self.model pageViewController:self.pageViewController viewControllerBeforeViewController:currentVC];
            viewControllers = @[previousVC, currentVC];
        }
        [self.pageViewController setViewControllers:viewControllers
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:YES
                                         completion:nil];

        return UIPageViewControllerSpineLocationMid;
    }
}

#pragma mark - Getters & Setters

- (Model *)model {
    if (!_model) {
        _model = [[Model alloc] init];
    }
    return _model;
}

@end
