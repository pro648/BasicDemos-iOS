//
//  Model.h
//  PageViewController
//
//  Created by pro648 on 2018/6/2.
//  Copyright © 2018 pro648. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class DataViewController;

@interface Model : NSObject <UIPageViewControllerDataSource>

- (DataViewController *)viewControllerAtIndex:(NSUInteger)index;

@end
