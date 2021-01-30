//
//  Child+Test2.m
//  category、load、initialize的本质
//
//  Created by pro648 on 2021/1/26.
//  

#import "Child+Test2.h"

@implementation Child (Test2)

- (void)test {
    NSLog(@"%d %s", __LINE__, __PRETTY_FUNCTION__);
}

- (void)run {
    NSLog(@"%d %s", __LINE__, __PRETTY_FUNCTION__);
}

- (void)eat {
    NSLog(@"%d %s", __LINE__, __PRETTY_FUNCTION__);
}

- (void)eat1 {
    NSLog(@"%d %s", __LINE__, __PRETTY_FUNCTION__);
}

+ (void)eat2 {
    NSLog(@"%d %s", __LINE__, __PRETTY_FUNCTION__);
}

+ (void)eat3 {
    NSLog(@"%d %s", __LINE__, __PRETTY_FUNCTION__);
}

@end
