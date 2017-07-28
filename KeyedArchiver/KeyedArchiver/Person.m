//
//  Person.m
//  KeyedArchiver
//
//  Created by ad on 27/07/2017.
//
//  详细介绍：https://github.com/pro648/tips/wiki/%E6%95%B0%E6%8D%AE%E5%AD%98%E5%82%A8%E4%B9%8B%E5%BD%92%E6%A1%A3%E8%A7%A3%E6%A1%A3-NSKeyedArchiver-NSKeyedUnarchiver

#import "Person.h"

@implementation Person

- (void)setName:(NSString *)name age:(NSInteger)age {
    self.name = name;
    self.age = age;
}

// 1.编码方法
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:@"PersonName"];
    [aCoder encodeInteger:self.age forKey:@"PersonAge"];
}

// 2.解码方法
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.name = [aDecoder decodeObjectForKey:@"PersonName"];
        self.age = [aDecoder decodeIntegerForKey:@"PersonAge"];
    }
    return self;
}

@end
