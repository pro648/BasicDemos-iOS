//
//  Engineer.m
//  Runtime
//
//  Created by pro648 on 2020/3/7.
//  Copyright © 2020 pro648. All rights reserved.
//

#import "Engineer.h"
#import <objc/runtime.h>
#import "Student.h"

@interface Engineer ()

@property (nonatomic, copy) NSString *name;

@end

@implementation Engineer

- (instancetype)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        self.name = name;
    }
    return self;
}

- (void)sayHi {
    NSLog(@"My name is %@", self.name);
}

- (void)testMetaClass {
    NSLog(@"----- %s -----", __func__);
    NSLog(@"This object is %p", self);
    NSLog(@"Class is %@, and super is %@.", [self class], [self superclass]);
    
    Class currentClass = [self class];
    for (int i=0; i<4; ++i) {
        NSLog(@"Following the isa pointer %d times gives %p", i+1, currentClass);
        currentClass = object_getClass(currentClass);
    }
    
    // 不能通过[Person class]获得元类
    NSLog(@"NSObject's meta class is %p", object_getClass([NSObject class]));
}

- (void)testSuperClass {
    NSLog(@"----- %s -----", __func__);
    NSLog(@"This object is %p.", self);
    NSLog(@"Class is %@, and super is %@.", [self class], [self superclass]);
    
    Class currentClass = [self class];
    Class currentMetaClass = object_getClass(currentClass);
    for (int i=0; i<4; ++i) {
        NSLog(@"Following the super pointer %d times gives %p", i+1, currentClass);
        currentClass = class_getSuperclass(currentClass);
    }
    
    for (int i=0; i<5; ++i) {
        NSLog(@"Following the meta class super pointer %d times gives %p", i+1, currentMetaClass);
        currentMetaClass = class_getSuperclass(currentMetaClass);
    }
    
    NSLog(@"NSObject's meta class is %p", object_getClass([NSObject class]));
}

- (void)testSelfAndSuper {
    NSLog(@"[self class] %@", [self class]);
    NSLog(@"[super class] %@", [super class]);
}

// MARK: - 动态方法解析

void otherRun(id self, SEL _cmd) {
    NSLog(@"%s", __func__);
}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    if (sel == @selector(run)) {
        class_addMethod([self class], sel, (IMP)otherRun, "v@:");
        return YES;
    } else {
        return [super resolveInstanceMethod:sel];
    }
}

// MARK: - 实例方法 消息转发

// 快速转发
//- (id)forwardingTargetForSelector:(SEL)aSelector {
//    if (aSelector == @selector(numberOfDaysInMonth:)) {
//        return [[Student alloc] init];
//    } else {
//        return [super forwardingTargetForSelector:aSelector];
//    }
//}

// 常规转发
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if (aSelector == @selector(numberOfDaysInMonth:)) {
        return [NSMethodSignature signatureWithObjCTypes:"i@:i"];
    } else {
        return [super methodSignatureForSelector:aSelector];
    }
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    NSLog(@"%@ %@", anInvocation.target, NSStringFromSelector(anInvocation.selector));
    [anInvocation invokeWithTarget:[[Student alloc] init]];
    
    int month;
    [anInvocation getArgument:&month atIndex:2];
    NSLog(@"%d", month + 10);
}

// MARK: - 类方法 消息转发
// 快速转发
+ (id)forwardingTargetForSelector:(SEL)aSelector {
    if (aSelector == @selector(numberOfDaysInMonth:)) {
        return [Student class];
    } else {
        return [super forwardingTargetForSelector:aSelector];
    }
}

// 常规转发
+ (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if (aSelector == @selector(numberOfDaysInMonth:)) {
        return [NSMethodSignature signatureWithObjCTypes:"i@:i"];
    } else {
        return [super methodSignatureForSelector:aSelector];
    }
}

+ (void)forwardInvocation:(NSInvocation *)anInvocation {
    NSLog(@"%@ %@", anInvocation.target, NSStringFromSelector(anInvocation.selector));
    [anInvocation invokeWithTarget:[Student class]];
    
    int month;
    [anInvocation getArgument:&month atIndex:2];
    NSLog(@"%d", month + 10);
}

@end
