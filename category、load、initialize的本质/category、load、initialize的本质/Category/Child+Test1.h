//
//  Child+Test1.h
//  category、load、initialize的本质
//
//  Created by pro648 on 2021/1/26.
//  

#import "Child.h"

NS_ASSUME_NONNULL_BEGIN

@interface Child (Test1)

@property (nonatomic, strong) NSString *title;
- (void)test;

@end

NS_ASSUME_NONNULL_END
