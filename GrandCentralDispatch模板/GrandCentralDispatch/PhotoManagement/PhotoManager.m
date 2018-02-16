//
//  PhotoManager.m
//  GrandCentralDispatch
//
//  Created by ad on 07/02/2018.
//

#import "PhotoManager.h"
#import <CoreImage/CoreImage.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface PhotoManager ()

@property (strong, nonatomic) NSMutableArray *photosArray;

@end

NSString * const baseURLString = @"https://raw.githubusercontent.com/wiki/pro648/tips/images/GCD";

@implementation PhotoManager

+ (instancetype)sharedManager {
    // 创建单例
    static PhotoManager *sharedPhotoManager = nil;
    if (!sharedPhotoManager) {
        sharedPhotoManager = [[PhotoManager alloc] init];
        // 初始化私有photosArray数组
        sharedPhotoManager->_photosArray = [NSMutableArray array];
    }
    return sharedPhotoManager;
}

#pragma mark - Unsafe Setter/Getters

// 这是一个写方法，其修改了私有可变数组对象。
- (void)addPhoto:(Photo *)photo {
    if (photo) {
        [_photosArray addObject:photo];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self postContentAddedNotification];
        });
    }
}

// 这是一个读方法，通过获取不可变副本防止调用者改变数据。
- (NSArray *)photos {
    return [NSArray arrayWithObject:self.photosArray];
}

#pragma mark - Public methods

- (void)downloadPhotosWithCompletionBlock:(BatchPhotoDownloadingCompletionBlock)completionBlock {
    __block NSError *error;
    
    for (int i=0; i<3; ++i) {
        NSURL *url;
        switch (i) {
            case 0:{
                NSString *urlString = [NSString stringWithFormat:@"%@%@",baseURLString,@"Penny.jpg"];
                url = [NSURL URLWithString:urlString];
                break;
            }
                
            case 1:{
                NSString *urlString = [NSString stringWithFormat:@"%@%@",baseURLString,@"Friends.jpg"];
                url = [NSURL URLWithString:urlString];
                break;
            }
                
            case 2:{
                NSString *urlString = [NSString stringWithFormat:@"%@%@",baseURLString,@"NightKing.jpg"];
                url = [NSURL URLWithString:urlString];
                break;
            }
                
            default:
                break;
        }
        
        Photo *photo = [[Photo alloc] initWithURL:url withCompletionBlock:^(UIImage *image, NSError *_error) {
            if (_error) {
                error = _error;
            }
        }];
        
        [[PhotoManager sharedManager] addPhoto:photo];
    }
    
    if (completionBlock) {
        completionBlock(error);
    }
}

#pragma mark - Private Methods

- (void)postContentAddedNotification {
    static NSNotification *notification = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        notification = [NSNotification notificationWithName:kPhotoManagerAddedContentNotification object:nil];
    });
    
    [[NSNotificationQueue defaultQueue] enqueueNotification:notification postingStyle:NSPostASAP coalesceMask:NSNotificationCoalescingOnName forModes:nil];
    
    
}

@end
