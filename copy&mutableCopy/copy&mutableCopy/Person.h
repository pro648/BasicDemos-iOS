//
//  Person.h
//  copy&mutableCopy
//
//  Created by ad on 03/08/2017.
//
//

#import <Foundation/Foundation.h>

@interface Person : NSObject <NSCopying>

@property (strong, nonatomic) NSString *name;
@property (assign, nonatomic) NSUInteger age;

- (void)setName:(NSString *)name withAge:(NSUInteger)age;

@end
