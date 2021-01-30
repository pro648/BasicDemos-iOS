//
//  Dog.m
//  category、load、initialize的本质
//
//  Created by pro648 on 2021/1/29.
//  

#import "Dog.h"

@implementation Dog

+ (void)initialize {
    NSLog(@"%d %s %@", __LINE__, __PRETTY_FUNCTION__, self);
}
@end
