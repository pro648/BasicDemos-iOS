//
//  Child+Test1.m
//  category、load、initialize的本质
//
//  Created by pro648 on 2021/1/26.
//  

#import "Child+Test1.h"

@implementation Child (Test1)

- (void)test {
    NSLog(@"%d %s", __LINE__, __PRETTY_FUNCTION__);
}

- (void)run {
    NSLog(@"%d %s", __LINE__, __PRETTY_FUNCTION__);
}

@end
