//
//  NotificationService.swift
//  NotificationService
//
//  Created by pro648 on 18/8/18
//  Copyright © 2018年 pro648. All rights reserved.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
//        bestAttemptContent?.body = "\(bestAttemptContent?.body ?? "Default Body") by pro648"
//        contentHandler(bestAttemptContent!)
        
        // Dig in the payload to get the attachment-url.
        guard let bestAttemptContent = bestAttemptContent,
            let attachmentURLAsString = request.content.userInfo["media-url"] as? String,
            let attachmentURL = URL(string: attachmentURLAsString) else {
                return
        }
        
        // Download the image and pass it to attachments if not nil.
        downloadImageFrom(url: attachmentURL) {(attachment) in
            
            if attachment != nil {
                bestAttemptContent.attachments = [attachment!]
                contentHandler(bestAttemptContent)
            }
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        if let contentHandler = contentHandler, let bestAttemptContent = bestAttemptContent {
            bestAttemptContent.title = "Incoming Image"
            contentHandler(bestAttemptContent)
        }
    }
}

extension NotificationService {
    private func downloadImageFrom(url: URL, with completionHandler: @escaping (UNNotificationAttachment?) -> Void) {
        let task = URLSession.shared.downloadTask(with: url) { (location, response, error) in
            // 1. Test URL and escape if URL not OK
            guard let location = location else {
                completionHandler(nil)
                return
            }
            
            // 2. Get current's user temporary directory path
            var urlPath = URL(fileURLWithPath: NSTemporaryDirectory())
            // 3. Add proper ending to url path, in the case .jpg (The system validates the content of attached files before scheduling the corresponding notification request. If an attached file is corrupted, invalid, or of an unsupported file type, the notificaiton request is not scheduled for delivery.)
            let uniqueURLString = ProcessInfo.processInfo.globallyUniqueString + ".png"
            urlPath = urlPath.appendingPathComponent(uniqueURLString)
            
            // 4. Move downloadUrl to newly created urlPath
            try? FileManager.default.moveItem(at: location, to: urlPath)
            
            // 5. Try adding the attachement and pass it to the completion handler
            do {
                let attachment = try UNNotificationAttachment(identifier: "picture", url: urlPath, options: nil)
                completionHandler(attachment)
            }
            catch {
                completionHandler(nil)
            }
        }
        task.resume()
    }
}
