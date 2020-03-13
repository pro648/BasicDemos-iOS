//
//  AllocateClass.m
//  Runtime
//
//  Created by pro648 on 2020/3/7.
//  Copyright © 2020 pro648. All rights reserved.
//

#import "AllocateClass.h"
#import <objc/runtime.h>

@implementation AllocateClass

void run(id self, SEL _cmd) {
    NSLog(@"--- %@ %s ---", self, sel_getName(_cmd));
}

void createClass() {
    // 创建类
    Class newCls = objc_allocateClassPair([NSObject class], "Dog", 0);
    
    // 添加方法
    class_addMethod(newCls, @selector(run), (IMP)run, "v@:");
    
    // 添加实例变量
    class_addIvar(newCls, "_age", sizeof(int), log2(sizeof(int)), @encode(int));
    class_addIvar(newCls, "_weight", sizeof(int), log2(sizeof(int)), @encode(int));

    // 注册类 注册后不可addIvar
    objc_registerClassPair(newCls);

    // 类占内存大小
//    NSLog(@"%zd", class_getInstanceSize(newCls));

    id dog = [[newCls alloc] init];
    [dog run];
    
    // 使用 KVC 设值、取值
    [dog setValue:@10 forKey:@"_age"];
    [dog setValue:@20 forKey:@"_weight"];
    NSLog(@"%@ %@", [dog valueForKey:@"_age"], [dog valueForKey:@"_weight"]);
    
    // 当newClass类及子类存在时，不能调用objc_disposeClassPair()函数，否则会抛出Attempt to use unknown class错误。
    dog = nil;
    // 不需要的时候释放newCls。
    objc_disposeClassPair(newCls);
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        createClass();
    }
    return self;
}

@end
