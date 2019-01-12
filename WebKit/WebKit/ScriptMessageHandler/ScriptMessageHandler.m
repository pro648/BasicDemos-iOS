//  ScriptMessageHandler.m
//  WebKit
//
//  Created by pro648 on 2018/12/24
//  Copyright © 2018 pro648. All rights reserved.
//

#import "ScriptMessageHandler.h"

@implementation ScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:@"didFetchTableOfContents"]) {
        id body = message.body;
        if ([body isKindOfClass:NSArray.class]) {
            self.messageBody = (NSArray *)body;
            NSLog(@"messageBody:%@",body);
        }
    }
}

- (NSArray *)messageBody {
    if (!_messageBody) {
        _messageBody = [NSArray array];
    }
    return _messageBody;
}

@end
