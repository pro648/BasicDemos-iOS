//  ImagePicker.h
//  WebKit
//
//  Created by pro648 on 2018/12/24
//  Copyright © 2018 pro648. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImagePicker : NSObject <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

- (void)showGallery:(void(^)(BOOL flag, NSURLResponse *response, NSData *data))cHandler;

@end

NS_ASSUME_NONNULL_END
