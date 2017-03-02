//
//  KVCMutableArray.h
//  KVC&KVODemo
//
//  Created by ad on 02/03/2017.
//
//

#import <Foundation/Foundation.h>

@interface KVCMutableArray : NSObject

@property (nonatomic, strong) NSMutableArray *array;

- (NSUInteger)countOfArray;
- (id)objectInArrayAtIndex:(NSUInteger)index;
- (void)insertObject:(id)object inArrayAtIndex:(NSUInteger)index;
- (void)removeObjectFromArrayAtIndex:(NSUInteger)index;
- (void)replaceObjectInArrayAtIndex:(NSUInteger)index withObject:(id)object;

@end
