//
//  Observer.m
//  KVC&KVO的本质
//
//  Created by pro648 on 2021/1/24.
//  

#import "Observer.h"

@implementation Observer

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    NSLog(@"%s - %@", __PRETTY_FUNCTION__, change);
}

@end
