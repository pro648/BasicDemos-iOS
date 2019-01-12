//  UIDelegateHandler.m
//  WebKit
//
//  Created by pro648 on 2018/12/24
//  Copyright © 2018 pro648. All rights reserved.
//

#import "UIDelegateHandler.h"

@implementation UIDelegateHandler

#pragma mark - WKUIDelegate

- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    if (navigationAction.targetFrame == nil) {
        NSURL *url = navigationAction.request.URL;
        NSString *itunes = @"^https?:\\/\\/itunes\\.apple\\.com\\/\\S+";
        NSString *mail = @"^mailto:\\S+";
        NSString *tel = @"^tel:\\/\\/\\+?\\d+";
        NSString *sms = @"^sms:\\/\\/\\+?\\d+";
        NSString *pattern = [NSString stringWithFormat:@"(%@)|(%@)|(%@)|(%@)",itunes, mail, tel, sms];
        if ([self validatePath:url.absoluteString withPattern:pattern]) {
            [UIApplication.sharedApplication openURL:url
                                             options:@{}
                                   completionHandler:nil];
        } else {
            [webView loadRequest:navigationAction.request];
        }
    }
    return nil;
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    NSString *msg = [NSString stringWithFormat:@"%@ %@",message, frame.request.URL.absoluteString];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert Panel"
                                                                             message:msg
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         completionHandler();
                                                     }];
    [alertController addAction:okAction];
    [self presentAlertController:alertController];
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    NSString *msg = [NSString stringWithFormat:@"%@ %@",frame.request.URL.absoluteString, message];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Confirm Panel"
                                                                             message:msg
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             completionHandler(NO);
                                                         }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         completionHandler(YES);
                                                     }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentAlertController:alertController];
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Text Input Panel"
                                                                             message:prompt
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             completionHandler(nil);
                                                         }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         UITextField *textField = alertController.textFields.firstObject;
                                                         completionHandler(textField.text);
                                                     }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentAlertController:alertController];
}

- (BOOL)validatePath:(NSString *)path withPattern:(NSString *)pattern {
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    if (error) {
        return NO;
    }
    
    NSRange range = [regex rangeOfFirstMatchInString:path
                                             options:NSMatchingReportCompletion
                                               range:NSMakeRange(0, path.length)];
    
    if (range.location == NSNotFound) {
        return NO;
    } else {
        return YES;
    }
}

- (void)presentAlertController:(UIAlertController *)alertController {
    UIViewController *vc = UIApplication.sharedApplication.keyWindow.rootViewController;
    [vc presentViewController:alertController
                     animated:YES
                   completion:nil];
}

@end
