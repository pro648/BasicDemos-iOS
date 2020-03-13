//
//  Safari.m
//  Runtime
//
//  Created by pro648 on 2020/3/7.
//  Copyright © 2020 pro648. All rights reserved.
//

#import "Safari.h"
#import "Engineer.h"

@implementation Safari

- (instancetype)init
{
    self = [super init];
    if (self) {
//        NSLog(@"[self class] = %@", [self class]);
//        NSLog(@"[super class] = %@", [super class]);
//        NSLog(@"[self superclass] = %@", [self superclass]);
//        NSLog(@"[super superclass] = %@", [super superclass]);
        
        [self testKindMember];
    }
    return self;
}

- (void)testKindMember {
    BOOL res1 = [[NSObject class] isKindOfClass:[NSObject class]];
    BOOL res2 = [[NSObject class] isMemberOfClass:[NSObject class]];
    BOOL res3 = [[Safari class] isKindOfClass:[Safari class]];
    BOOL res4 = [[Safari class] isMemberOfClass:[Safari class]];
    NSLog(@"%i %i %i %i", res1, res2, res3, res4);
    
//    Engineer *engineer = [[Engineer alloc] init];
//    BOOL res5 = [engineer isKindOfClass:[NSObject class]];
//    BOOL res6 = [engineer isMemberOfClass:[NSObject class]];
//    BOOL res7 = [engineer isKindOfClass:[Engineer class]];
//    BOOL res8 = [engineer isMemberOfClass:[Engineer class]];
//    NSLog(@"%i %i %i %i", res5, res6, res7, res8);
}

@end
