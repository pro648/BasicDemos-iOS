//
//  Model.m
//  PageViewController
//
//  Created by pro648 on 2018/6/2.
//  Copyright © 2018 pro648. All rights reserved.
//


#import "Model.h"
#import "DataViewController.h"

@interface Model ()

@property (nonatomic, strong, readonly) NSArray *days;
@property (nonatomic, strong, readonly) NSArray *quotes;

@end

@implementation Model

- (instancetype)init {
    self = [super init];
    if (self) {
        // 创建数据模型。
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        _days = [[dateFormatter weekdaySymbols] copy];
        
        _quotes = @[@"Everyone who isn’t us is an enemy.",
                    @"When you play the game of thrones you win or you die. There is no middle ground.",
                    @"You’re a clever man. But you’re not half as clever as you think you are.",
                    @"Nobody cares what your father once told you.",
                    @"Everywhere in the world, they hurt little girls.",
                    @"I choose violence.",
                    @"What is Dead May Never Die"
                    ];
    }
    return self;
}

- (DataViewController *)viewControllerAtIndex:(NSUInteger)index {
    // 返回指定index的视图控制器。
    if (self.days.count == 0 || index >= self.days.count) {
        return nil;
    }
    
    DataViewController *dataVC = [[DataViewController alloc] init];
    dataVC.itemIndex = index;
    dataVC.day = self.days[index];
    dataVC.quote = self.quotes[index];
    return dataVC;
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    // 返回上一个视图控制器。
    NSUInteger index = ((DataViewController *)viewController).itemIndex;
    if (index == 0 || index == NSNotFound) {
        return nil;
    }
    
    --index;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    // 返回下一个视图控制器。
    NSUInteger index = ((DataViewController *)viewController).itemIndex;
    if (index == self.days.count - 1 || index == NSNotFound) {
        return nil;
    }
    
    ++index;
    return [self viewControllerAtIndex:index];
}

// 初始页。
- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    NSUInteger currentPage = 2;
    
    if (currentPage >= self.days.count) {
        currentPage = 0;
    }
    
    DataViewController *dataVC = (DataViewController *)pageViewController.viewControllers.firstObject;
    dataVC.itemIndex = currentPage;
    dataVC.day = self.days[currentPage];
    dataVC.quote = self.quotes[currentPage];
    return currentPage;
}

// 共多少页。
- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return self.days.count;
}

@end

