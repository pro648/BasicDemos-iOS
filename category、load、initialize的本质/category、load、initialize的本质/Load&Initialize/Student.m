//
//  Student.m
//  category、load、initialize的本质
//
//  Created by pro648 on 2021/1/28.
//  

#import "Student.h"

@implementation Student

+ (void)load {
    NSLog(@"%d %s", __LINE__, __PRETTY_FUNCTION__);
}

//+ (void)initialize {
//    NSLog(@"%d %s %@", __LINE__, __PRETTY_FUNCTION__, self);
//}

@end
