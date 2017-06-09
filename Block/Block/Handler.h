//
//  Handler.h
//  Block
//
//  Created by ad on 09/06/2017.
//
//  详细博文介绍：https://github.com/pro648/tips/wiki/Block%E7%9A%84%E7%94%A8%E6%B3%95

#import <Foundation/Foundation.h>

@interface Handler : NSObject

- (void)addNumber:(int)number1 withNumber:(int)number2 andCompletionHandler:(void(^)(int result))completionHandler;

@end
