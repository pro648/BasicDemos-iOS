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
        self.firstName = @"";
        self.age = 0;
        self.lastName = @"";
        self.cousins = [KVCMutableArray new];
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

@end
