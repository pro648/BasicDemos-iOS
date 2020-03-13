//
//  PremiumUser.m
//  Runtime
//
//  Created by pro648 on 2020/3/7.
//  Copyright © 2020 pro648. All rights reserved.
//

#import "PremiumUser.h"
#import <objc/runtime.h>

@implementation PremiumUser

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class cls = [self class];
        SEL originalSelector = @selector(happyBirthday);
        SEL swizzledSelector = @selector(pr_happyBirthday);
        
        Method originalMethod = class_getInstanceMethod(cls, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(cls, swizzledSelector);
        
        BOOL success = class_addMethod(cls, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (success) {
            Method original = class_getInstanceMethod(cls, originalSelector);
            Method swizzle = class_getInstanceMethod(cls, swizzledSelector);
            
            IMP oriIMP = method_getImplementation(original);
            IMP swiIMP = method_getImplementation(swizzle);
            
            class_replaceMethod(cls, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
            
            //            Method original = class_getInstanceMethod(cls, originalSelector);
            //            Method swizzle = class_getInstanceMethod(cls, swizzledSelector);
            //
            //            IMP oriIMP = method_getImplementation(original);
            //            IMP swiIMP = method_getImplementation(swizzle);
        } else {  // 由于当前类没有重写happyBirthday方法，不可直接交换。
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
        
//        method_exchangeImplementations(originalMethod, swizzledMethod);
    });
}

- (void)pr_happyBirthday {
    NSLog(@"+++ %s +++", __func__);
    
    [self pr_happyBirthday];
}

@end
