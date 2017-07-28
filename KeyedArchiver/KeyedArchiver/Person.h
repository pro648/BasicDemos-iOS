//
//  Person.h
//  KeyedArchiver
//
//  Created by ad on 27/07/2017.
//
//

#import <Foundation/Foundation.h>

@interface Person : NSObject <NSCoding>

@property (strong, nonatomic) NSString *name;
@property (assign, nonatomic) NSInteger age;

- (void)setName:(NSString *)name age:(NSInteger)age;

@end
