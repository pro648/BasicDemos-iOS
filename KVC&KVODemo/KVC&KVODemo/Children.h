//
//  Children.h
//  KVC&KVODemo
//
//  Created by ad on 01/03/2017.
//
//

#import <Foundation/Foundation.h>
#import "KVCMutableArray.h"

@interface Children : NSObject

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, assign) NSUInteger age;
@property (nonatomic, strong) Children *child;
@property (nonatomic, strong) NSString *fullName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) KVCMutableArray *cousins;

@end
