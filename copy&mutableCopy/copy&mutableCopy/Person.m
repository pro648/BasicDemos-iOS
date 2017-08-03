//
//  Person.m
//  copy&mutableCopy
//
//  Created by ad on 03/08/2017.
//
//  详细介绍：https://github.com/pro648/tips/wiki/%E6%B7%B1%E5%A4%8D%E5%88%B6%E3%80%81%E6%B5%85%E5%A4%8D%E5%88%B6%E3%80%81copy%E3%80%81mutableCopy

#import "Person.h"

@implementation Person

- (void)setName:(NSString *)name withAge:(NSUInteger)age {
    _name = name;
    _age = age;
}

- (id)copyWithZone:(NSZone *)zone {
    Person *person = [[Person allocWithZone:zone] init];
    [person setName:self.name withAge:self.age];
    return person;
}

@end
