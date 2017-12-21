//
//  KVCMutableArray.m
//  KVC&KVODemo
//
//  Created by ad on 02/03/2017.
//
//  详细介绍：https://github.com/pro648/tips/wiki/KVC%E5%92%8CKVO%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B0

#import "KVCMutableArray.h"

@implementation KVCMutableArray

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _array = [NSMutableArray new];
    }
    
    return self;
}

- (NSUInteger)countOfArray
{
    return self.array.count;
}

- (id)objectInArrayAtIndex:(NSUInteger)index
{
    return [self.array objectAtIndex:index];
}

- (void)insertObject:(id)object inArrayAtIndex:(NSUInteger)index
{
    [self.array insertObject:object atIndex:index];
}

- (void)removeObjectFromArrayAtIndex:(NSUInteger)index
{
    [self.array removeObjectAtIndex:index];
}

- (void)replaceObjectInArrayAtIndex:(NSUInteger)index withObject:(id)object
{
    [self.array replaceObjectAtIndex:index withObject:object];
}

@end
