//  ContentsViewController.h
//  WebKit
//
//  Created by pro648 on 2018/12/24
//  Copyright © 2018 pro648. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Entry.h"

NS_ASSUME_NONNULL_BEGIN

@interface ContentsViewController : UIViewController

@property (nonatomic, strong) NSArray *messageBody;
@property (nonatomic, copy) void(^didSelectEntry)(Entry *entry);

@end

NS_ASSUME_NONNULL_END
