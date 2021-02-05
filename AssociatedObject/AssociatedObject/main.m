//
//  main.m
//  AssociatedObject
//
//  Created by pro648 on 2021/2/2.
//  
//  详细介绍：https://github.com/pro648/tips/blob/master/sources/%E5%85%B3%E8%81%94%E5%AF%B9%E8%B1%A1%20Associated%20Object%20%E7%9A%84%E6%9C%AC%E8%B4%A8.md

#import <Foundation/Foundation.h>
#import "Child+Test.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        Child *child1 = [[Child alloc] init];
        child1.name = @"pro648";
        
        Child *child2 = [[Child alloc] init];
        child2.name = @"It's Time";
        
        NSLog(@"child1 name:%@ -- child2 name:%@", child1.name, child2.name);
        
    }
    return 0;
}
