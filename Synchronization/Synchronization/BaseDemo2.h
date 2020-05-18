//
//  BaseDemo2.h
//  Synchronization
//
//  Created by pro648 on 2020/5/8.
//  Copyright © 2020 pro648. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseDemo2 : NSObject

- (void)ticketTest;
- (void)moneyTest;
- (void)otherTest;

// MARK: - 子类使用

- (void)__saveMoney;
- (void)__drawMoney;
- (void)__saleTicket;

@end

NS_ASSUME_NONNULL_END
