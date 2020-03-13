//
//  UIView+DefaultColor.m
//  Runtime
//
//  Created by pro648 on 2020/3/7.
//  Copyright © 2020 pro648. All rights reserved.
//

#import "UIView+DefaultColor.h"
#import <objc/runtime.h>

static void *kDefaultColorKey = &kDefaultColorKey;

@implementation UIView (DefaultColor)

- (UIColor *)defaultColor {
//    return objc_getAssociatedObject(self, kDefaultColorKey);
    return objc_getAssociatedObject(self, @selector(defaultColor));
}

- (void)setDefaultColor:(UIColor *)defaultColor {
//    objc_setAssociatedObject(self, kDefaultColorKey, defaultColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, @selector(defaultColor), defaultColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
