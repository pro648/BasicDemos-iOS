//
//  Person.m
//  KVC&KVO的本质
//
//  Created by pro648 on 2021/1/24.
//  

#import "Person.h"

@implementation Person

// MARK: - setValue:forKey:

//- (void)setAge:(int)age {
//    _age = age;
//    NSLog(@"%s %d", __PRETTY_FUNCTION__, age);
//}
//
//- (void)_setAge:(int)age {
//    _age = age;
//    NSLog(@"%s %d", __PRETTY_FUNCTION__, age);
//}

// MARK: - valueForKey:

- (int)getAge {
    return 22;
}

// 没有访问器方法，是否运行直接访问变量。默认YES。
+ (BOOL)accessInstanceVariablesDirectly {
    return YES;
//    return NO;
}

// 可以验证内部实现了willChangeValueForKey: didChangeValueForKey:
- (void)willChangeValueForKey:(NSString *)key {
    [super willChangeValueForKey:key];
    
    NSLog(@"%s %@", __PRETTY_FUNCTION__, key);
}

- (void)didChangeValueForKey:(NSString *)key {
    NSLog(@"%s - begin - %@", __PRETTY_FUNCTION__, key);
    
    [super didChangeValueForKey:key];
    
    NSLog(@"%s - end - %@", __PRETTY_FUNCTION__, key);
}

@end
