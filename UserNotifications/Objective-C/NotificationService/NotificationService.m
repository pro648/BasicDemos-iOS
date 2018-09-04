//
//  NotificationService.m
//  NotificationService
//
//  Created by pro648 on 18/8/26
//  Copyright © 2018年 pro648. All rights reserved.
//

#import "NotificationService.h"

@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    
//    NSString *body = self.bestAttemptContent.body;
//    if (body.length > 0) {
//        self.bestAttemptContent.body = [NSString stringWithFormat:@"%@ by pro648",self.bestAttemptContent.body];
//    } else {
//        self.bestAttemptContent.body = @"Default Body by pro648";
//    }
//    self.contentHandler(self.bestAttemptContent);
    
    // Dig in the payload to get the attachment-url.
    if (! self.bestAttemptContent) {
        return;
    }
    
    NSString *attachmentURLAsString = (NSString *)request.content.userInfo[@"media-url"];
    if (!attachmentURLAsString) {
        return;
    }
    
    NSURL *attachmentURL = [NSURL URLWithString:attachmentURLAsString];
    
    // Download the image and pass it to attachments if not nil.
    [self downloadImageFromURL:attachmentURL completion:^(UNNotificationAttachment *attachment) {
            self.bestAttemptContent.attachments = [NSArray arrayWithObject:attachment];
            self.contentHandler(self.bestAttemptContent);
    }];
}

- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    if (self.contentHandler && self.bestAttemptContent) {
        self.bestAttemptContent.title = @"Incoming Image";
        self.contentHandler(self.bestAttemptContent);
    }
}

- (void)downloadImageFromURL:(NSURL *)url completion:(void(^)(UNNotificationAttachment *attachment))completionHandler {
    NSURLSessionDownloadTask *task = [NSURLSession.sharedSession downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // 1. Test URL and escape if URL not OK
        if (!location) {
            completionHandler(nil);
            return ;
        }
        
        // 2. Get current's user temporary directory path
        NSURL *urlPath = [NSURL fileURLWithPath:NSTemporaryDirectory()];
        // 3. Add proper ending to url path, in the case .jpg (The system validates the content of attached files before scheduling the corresponding notification request. If an attached file is corrupted, invalid, or of an unsupported file type, the notificaiton request is not scheduled for delivery.)
        NSString *uniqueURLString = [NSProcessInfo.processInfo.globallyUniqueString stringByAppendingString:@".png"];
        urlPath = [urlPath URLByAppendingPathComponent:uniqueURLString];
        
        // 4. Move downloadUrl to newly created urlPath
        if ([[NSFileManager defaultManager] moveItemAtURL:location toURL:urlPath error:NULL]) {
            UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:@"picture" URL:urlPath options:nil error:nil];
            completionHandler(attachment);
        }else {
            completionHandler(nil);
        }
    }];
    [task resume];
}

@end
