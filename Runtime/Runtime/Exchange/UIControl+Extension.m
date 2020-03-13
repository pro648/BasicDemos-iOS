//
//  UIControl+Extension.m
//  Runtime
//
//  Created by pro648 on 22020/3/7.
//  Copyright © 2020 pro648. All rights reserved.
//

#import "UIControl+Extension.h"
#import <objc/runtime.h>

@implementation UIControl (Extension)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class cls = [self class];
        
        SEL originalSelector = @selector(sendAction:to:forEvent:);
        SEL swizzledSelector = @selector(pr_sendAction:to:forEvent:);
        
        Method originalMethod = class_getInstanceMethod(cls, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(cls, swizzledSelector);
        
        BOOL didAddMethod = class_addMethod(cls, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (didAddMethod) {
            class_replaceMethod(cls, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (void)pr_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    // 进行所需的处理
    NSLog(@"--- %@ --- %@ --- %@ ---", self, NSStringFromSelector(action), target);
    
    [self pr_sendAction:action to:target forEvent:event];
}

@end
