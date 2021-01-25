//
//  Child.m
//  KVC&KVO的本质
//
//  Created by pro648 on 2021/1/21.
//  

#import "Child.h"

@implementation Child

- (void)setAge:(int)age {
    NSLog(@"begin - setAge:%d", age);
    _age = age;
    NSLog(@"end - setAge:%d", age);
    
//    NSLog(@"KVO是否通过重写setAge:方法实现？age:%d", age);
}

- (void)willChangeValueForKey:(NSString *)key {
    NSLog(@"willChangeValueForKey: - begin");
    [super willChangeValueForKey:key];
    NSLog(@"willChangeValueForKey: - end");
}

// 验证didChangeValueForKey:调用了KVO
- (void)didChangeValueForKey:(NSString *)key {
    NSLog(@"didChangeValueForKey: - begin");
    [super didChangeValueForKey:key];
    NSLog(@"didChangeValueForKey: - end");
}

@end
