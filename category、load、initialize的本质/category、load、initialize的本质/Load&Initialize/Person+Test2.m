//
//  Person+Test2.m
//  category、load、initialize的本质
//
//  Created by pro648 on 2021/1/28.
//  

#import "Person+Test2.h"

@implementation Person (Test2)

+ (void)load {
    NSLog(@"%d %s", __LINE__, __PRETTY_FUNCTION__);
}

+ (void)initialize {
    if (self == [Person self]) {
        NSLog(@"%d %s %@", __LINE__, __PRETTY_FUNCTION__, self);
    }
}

@end
