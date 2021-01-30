//
//  Child+Test2.h
//  category、load、initialize的本质
//
//  Created by pro648 on 2021/1/26.
//  

#import "Child.h"

NS_ASSUME_NONNULL_BEGIN

@interface Child (Test2) <NSCoding, NSCopying>

@property (nonatomic, assign) int weight;
@property (nonatomic, assign) double height;
- (void)eat;

- (void)test;

@end

NS_ASSUME_NONNULL_END
