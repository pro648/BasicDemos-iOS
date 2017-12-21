//
//  Children.m
//  KVC&KVODemo
//
//  Created by ad on 01/03/2017.
//
//  详细介绍：https://github.com/pro648/tips/wiki/KVC%E5%92%8CKVO%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B0

#import "Children.h"

@implementation Children

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _firstName = @"";
        _age = 0;
        _lastName = @"";
        _cousins = [KVCMutableArray new];
    }
    
    return self;
}

- (NSString *)fullName
{
    return [NSString stringWithFormat:@"%@ %@",self.firstName,self.lastName];
}

+ (NSSet *)keyPathsForValuesAffectingFullName
{
    return [NSSet setWithObjects:@"firstName",@"lastName", nil];
}

+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key
{
    BOOL automatic = NO;
    if ([key isEqualToString:@"firstName"])
    {
        automatic = NO;
    } else {
        automatic = [super automaticallyNotifiesObserversForKey:key];
    }
    return automatic;
}

@end
