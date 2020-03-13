//
//  NSMutableArray+Extension.m
//  Runtime
//
//  Created by pro648 on 2020/3/7.
//  Copyright © 2020 pro648. All rights reserved.
//

#import "NSMutableArray+Extension.h"
#import <objc/runtime.h>

@implementation NSMutableArray (Extension)

+ (void)load {
    // 类簇 NSString、NSDictionary、NSMutableArray、NSNumber，真实类型是其他类型。
    Class cls = objc_getClass("__NSArrayM");
    Method originalMethod = class_getInstanceMethod(cls, @selector(insertObject:atIndex:));
    Method swizzledMethod = class_getInstanceMethod(cls, @selector(pr_insertObject:atIndex:));
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

- (void)pr_insertObject:(id)anObject atIndex:(NSUInteger)index {
    if (!anObject) {
        return;
    }
    
    [self pr_insertObject:anObject atIndex:index];
}

@end
