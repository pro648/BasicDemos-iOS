//
//  BaseDemo2.m
//  Synchronization
//
//  Created by pro648 on 2020/5/8.
//  Copyright © 2020 pro648. All rights reserved.
//

#import "BaseDemo2.h"

@interface BaseDemo2 ()

@property (nonatomic, assign) int ticketsCount;
@property (nonatomic, assign) int money;

@end

@implementation BaseDemo2

// MARK: - Money

- (void)moneyTest {
    self.money = 100;
    
    dispatch_queue_t queue = dispatch_get_global_queue(QOS_CLASS_UTILITY, 0);
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 10; ++i) {
            [self __saveMoney];
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 10; ++i) {
            [self __drawMoney];
        }
    });
}

- (void)__drawMoney {
    
    int oldMoney = self.money;
    sleep(1);
    oldMoney -= 20;
    self.money = oldMoney;
    
    NSLog(@"取20元，还剩%d元 -- %@", oldMoney, [NSThread currentThread]);
}

- (void)__saveMoney {
    
    int oldMoney = self.money;
    sleep(1);
    oldMoney += 50;
    self.money = oldMoney;
    
    NSLog(@"存50元，还剩%d元 -- %@", oldMoney, [NSThread currentThread]);
}

// MARK: - Sale Ticket

- (void)ticketTest {
    self.ticketsCount = 15;
    
    dispatch_queue_t queue = dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0);
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; ++i) {
            [self __saleTicket];
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; ++i) {
            [self __saleTicket];
        }
    });

    dispatch_async(queue, ^{
        for (int i = 0; i < 5; ++i) {
            [self __saleTicket];
        }
    });
}

- (void)__saleTicket {
    
    int oldTicketsCount = self.ticketsCount;
    sleep(1);
    oldTicketsCount--;
    self.ticketsCount = oldTicketsCount;
    
    NSLog(@"还剩%d张票 -- %@", oldTicketsCount, [NSThread currentThread]);
}

- (void)otherTest {
    
}

@end
