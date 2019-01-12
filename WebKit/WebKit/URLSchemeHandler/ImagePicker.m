//  ImagePicker.m
//  WebKit
//
//  Created by pro648 on 2018/12/24
//  Copyright © 2018 pro648. All rights reserved.
//

#import "ImagePicker.h"

@interface ImagePicker ()

@property (nonatomic, copy) void(^completionHandler)(BOOL flag, NSURLResponse *response, NSData *data);

@end

@implementation ImagePicker

- (void)showGallery:(void(^)(BOOL flag, NSURLResponse *response, NSData *data))cHandler {
    UIViewController *viewController = UIApplication.sharedApplication.delegate.window.rootViewController;
    self.completionHandler = cHandler;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    [viewController presentViewController:picker
                                 animated:YES
                               completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    [picker dismissViewControllerAnimated:YES
                               completion:nil];
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    NSData *data = UIImagePNGRepresentation(image);
    NSURLResponse *response = [[NSURLResponse alloc] initWithURL:[NSURL URLWithString:@"custom-scheme://"]
                                                        MIMEType:@"image/png"
                                           expectedContentLength:data.length
                                                textEncodingName:NULL];
    if (self.completionHandler) {
        self.completionHandler(YES, response, data);
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES
                               completion:nil];
    
    if (self.completionHandler) {
        self.completionHandler(NO, nil, nil);
    }
}

@end
