//
//  Handler.m
//  Block
//
//  Created by ad on 09/06/2017.
//
//

#import "Handler.h"

@implementation Handler

- (void)addNumber:(int)number1 withNumber:(int)number2 andCompletionHandler:(void (^)(int))completionHandler{
    int result = number1 + number2;
    completionHandler(result);
}

@end
