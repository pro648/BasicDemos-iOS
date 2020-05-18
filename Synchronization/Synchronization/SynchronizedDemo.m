//
//  SynchronizedDemo.m
//  Synchronization
//
//  Created by pro648 on 2020/5/8.
//  Copyright © 2020 pro648. All rights reserved.
//
// [@synchronized](https://github.com/pro648/tips/wiki/%E7%BA%BF%E7%A8%8B%E5%90%8C%E6%AD%A5%E4%B9%8B@synchronized)

#import "SynchronizedDemo.h"

// 如果三把锁都传入 self，会导致存取款与卖票不能同时进行。
// 如果有SynchronizedDemo对象，会导致self不同，锁也不同，不能起到加锁目的。

@interface SynchronizedDemo ()

@property (nonatomic, strong) NSMutableArray *elements;
@property (nonatomic, strong) NSLock *lock;

@end

@implementation SynchronizedDemo

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.elements = [NSMutableArray array];
        self.lock = [[NSLock alloc] init];
        
        [self push:@"a"];
    }
    return self;
}

- (void)__drawMoney {
    @synchronized (self) {
        [super __drawMoney];
    }
}

- (void)__saveMoney {
    @synchronized (self) {
        [super __saveMoney];
    }
}

- (void)__saleTicket {
    static NSObject *lock;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lock = [[NSObject alloc] init];
    });
    
    @synchronized (lock) {
        [super __saleTicket];
    }
}

- (void)otherTest {
    
    // @synchronized 是递归锁
    @synchronized ([self class]) {
        NSLog(@"pro648");
        
        [self otherTest];
    }
}

- (void)push:(NSString *)element {
//    [self.lock lock];
//
//    [self.elements addObject:element];
//
//    [self.lock unlock];
    
    @synchronized (self) {
        [self.elements addObject:element];
    }
}

@end
