//
//  Engineer.h
//  Runtime
//
//  Created by pro648 on 2020/3/7.
//  Copyright © 2020 pro648. All rights reserved.
//

#import "Person.h"

NS_ASSUME_NONNULL_BEGIN

@interface Engineer : Person

- (instancetype)initWithName:(NSString *)name;

- (void)sayHi;

- (void)testMetaClass;
- (void)testSuperClass;

- (void)testSelfAndSuper;

- (void)run;
- (void)playVideo;

- (int)numberOfDaysInMonth:(int)month;
+ (int)numberOfDaysInMonth:(int)month;

@end

NS_ASSUME_NONNULL_END
