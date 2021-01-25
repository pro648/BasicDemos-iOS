//
//  NSKVONotifying_Child.m
//  KVC&KVO的本质
//
//  Created by pro648 on 2021/1/21.
//  

#import "NSKVONotifying_Child.h"
#import <objc/runtime.h>

@implementation NSKVONotifying_Child

//- (void)setAge:(int)age {
//    _NSSetIntValueAndNotify();
//}
//
//void _NSSetIntValueAndNotify() {
//    [self willChangeValueForKey:@"age"];
//    [super setAge:age];
//    [self didChangeValueForKey:@"age"];
//}
//
//- (void)didChangeValueForKey:(NSString *)key {
//    // 通知监听器，key属性发生了改变。
//    [observer observeValueForKeyPath:key ofObject:self change:nil context:nil];
//}

- (Class)class {
    return class_getSuperclass(object_getClass(self));
}

- (void)dealloc {
    // 执行清理工作
}

- (BOOL)isKVOA {
    return YES;
}

@end
