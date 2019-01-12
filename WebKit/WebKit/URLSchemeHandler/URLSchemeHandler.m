//  URLSchemeHandler.m
//  WebKit
//
//  Created by pro648 on 2018/12/24
//  Copyright © 2018 pro648. All rights reserved.
//

#import "URLSchemeHandler.h"

@implementation URLSchemeHandler

- (void)webView:(WKWebView *)webView startURLSchemeTask:(id<WKURLSchemeTask>)urlSchemeTask {
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0), ^{
        NSURL *url = urlSchemeTask.request.URL;
        if ([url.absoluteString containsString:@"custom-scheme"]) {
            NSArray<NSURLQueryItem *> *queryItems = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:YES].queryItems;
            for (NSURLQueryItem *item in queryItems) {
                
                // example: custom-scheme://path?type=remote&url=https://placehold.it/120x120&text=image1
                if ([item.name isEqualToString:@"type"] && [item.value isEqualToString:@"remote"]) {
                    for (NSURLQueryItem *queryParams in queryItems) {
                        if ([queryParams.name isEqualToString:@"url"]) {
                            NSString *path = queryParams.value;
                            path = [path stringByReplacingOccurrencesOfString:@"\\" withString:@""];
                            
                            // 获取图片
                            NSURLSession *session = [NSURLSession sharedSession];
                            NSURLSessionDataTask *task = [session dataTaskWithURL:[NSURL URLWithString:path] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                [urlSchemeTask didReceiveResponse:response];
                                [urlSchemeTask didReceiveData:data];
                                [urlSchemeTask didFinish];
                            }];
                            [task resume];
                        }
                    }
                } else if ([item.name isEqualToString:@"type"] && [item.value isEqualToString:@"photos"]) { // example: custom-scheme://path?type=photos
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.imagePicker = [[ImagePicker alloc] init];
                        [self.imagePicker showGallery:^(BOOL flag, NSURLResponse * _Nonnull response, NSData * _Nonnull data) {
                            if (flag) {
                                [urlSchemeTask didReceiveResponse:response];
                                [urlSchemeTask didReceiveData:data];
                                [urlSchemeTask didFinish];
                            } else {
                                NSError *error = [NSError errorWithDomain:urlSchemeTask.request.URL.absoluteString code:0 userInfo:NULL];
                                [urlSchemeTask didFailWithError:error];
                            }
                        }];
                    });
                }
            }
        }
    });
}

- (void)webView:(WKWebView *)webView stopURLSchemeTask:(id<WKURLSchemeTask>)urlSchemeTask {
    NSError *error = [NSError errorWithDomain:urlSchemeTask.request.URL.absoluteString code:0 userInfo:NULL];
    [urlSchemeTask didFailWithError:error];
}

@end
