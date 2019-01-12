//  ScriptMessageHandler.h
//  WebKit
//
//  Created by pro648 on 2018/12/24
//  Copyright © 2018 pro648. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ScriptMessageHandler : NSObject <WKScriptMessageHandler>

@property (nonatomic, strong) NSArray *messageBody;

@end

NS_ASSUME_NONNULL_END
