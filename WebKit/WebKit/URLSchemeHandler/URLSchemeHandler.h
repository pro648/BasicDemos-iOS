//  URLSchemeHandler.h
//  WebKit
//
//  Created by pro648 on 2018/12/24
//  Copyright © 2018 pro648. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import "ImagePicker.h"

NS_ASSUME_NONNULL_BEGIN

@interface URLSchemeHandler : NSObject <WKURLSchemeHandler>

@property (nonatomic, strong) ImagePicker *imagePicker;

@end

NS_ASSUME_NONNULL_END
