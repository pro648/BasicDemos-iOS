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
@property (strong, nonatomic) dispatch_queue_t concurrentPhotoQueue;    // 添加此属性。

@end

NSString * const baseURLString = @"https://raw.githubusercontent.com/wiki/pro648/tips/images/GCD";

@implementation PhotoManager

+ (instancetype)sharedManager {
//    // 创建单例
//    static PhotoManager *sharedPhotoManager = nil;
//    if (!sharedPhotoManager) {
//        // 通过使用sleepForTimeInterval:方法强制进行环境切换。
//        [NSThread sleepForTimeInterval:2.0];
//        sharedPhotoManager = [[PhotoManager alloc] init];
//        NSLog(@"%i %s",__LINE__, __PRETTY_FUNCTION__);
//        NSLog(@"Singleton has memory address at: %@",sharedPhotoManager);
//        [NSThread sleepForTimeInterval:2.0];
//        // 初始化私有photosArray数组
//        sharedPhotoManager->_photosArray = [NSMutableArray array];
//    }
    
    // 创建单例
    static PhotoManager *sharedPhotoManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedPhotoManager = [[PhotoManager alloc] init];
        // 初始化私有photosArray数组
        sharedPhotoManager->_photosArray = [NSMutableArray array];
        
        // 初始化concurrentPhotoQueue。
        sharedPhotoManager->_concurrentPhotoQueue = dispatch_queue_create("com.GCD.photoQueue", DISPATCH_QUEUE_CONCURRENT);
    });
    return sharedPhotoManager;
}

#pragma mark - Unsafe Setter/Getters

// 这是一个写方法，其修改了私有可变数组对象。
- (void)addPhoto:(Photo *)photo {
    if (photo) {
        // 将写操作添加到barrier函数，以便执行到写操作时队列只执行这一项任务。
        dispatch_barrier_async(self.concurrentPhotoQueue, ^{
            // 由于dispatch_barrier_async函数的存在，执行到下面操作时，concurrentPhotoQueue队列不会执行其他任务。
            [_photosArray addObject:photo];
            
            // 因为要更新UI，所以在主队列发送通知。
            dispatch_async(dispatch_get_main_queue(), ^{
                [self postContentAddedNotification];
            });
        });
    }
}

// 这是一个读方法，通过获取不可变副本防止调用者改变数据。
- (NSArray *)photos {
    //  使用__block修饰，以便块可以修改array内容。
    __block NSArray *array;
    
    // 同步执行读操作。
    dispatch_sync(self.concurrentPhotoQueue, ^{
        // 将读操作结果保存到array，以便返回给调用者。
        array = self.photosArray;
    });
    return array;
}

#pragma mark - Public methods

- (void)downloadPhotosWithCompletionBlock:(BatchPhotoDownloadingCompletionBlock)completionBlock {
    /*
    // 因为是在主线程中执行dispatch_group_wait，使用dispatch_async将整个代码添加到其他队列避免堵塞主线程。
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        // 创建dispatch group,其更像是未完成任务的计数器。
        dispatch_group_t downloadGroup = dispatch_group_create();
        
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
            
            // 增加dispatch group中未完成任务数，必须与dispatch_group_leave成对使用。
            dispatch_group_enter(downloadGroup);
            Photo *photo = [[Photo alloc] initWithURL:url withCompletionBlock:^(UIImage *image, NSError *_error) {
                if (_error) {
                    error = _error;
                }
                
                // 减小dispatch group中未完成任务数，必须与dispatch_group_enter成对使用。
                dispatch_group_leave(downloadGroup);
            }];
            
            [[PhotoManager sharedManager] addPhoto:photo];
        }
        
        // 等待downloadGroup内任务完成。
        dispatch_group_wait(downloadGroup, DISPATCH_TIME_FOREVER);
        
        // 目前，所有图片已下载完成。在主队列中调用完成处理程序。
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completionBlock) {
                completionBlock(error);
            }
        });
    });
     */
    
    // 因为dispatch_group_notify不会堵塞主线程，这里不需要使用dispatch_async。
    dispatch_group_t downloadGroup = dispatch_group_create();
    __block NSError *error;
    
    // 使用dispatch_apply并发枚举。
    dispatch_apply(3, dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^(size_t i) {
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
        
        dispatch_group_enter(downloadGroup);
        Photo *photo = [[Photo alloc] initWithURL:url withCompletionBlock:^(UIImage *image, NSError *_error) {
            if (_error) {
                error = _error;
            }
            
            dispatch_group_leave(downloadGroup);
        }];
        
        [[PhotoManager sharedManager] addPhoto:photo];
    });
    
    // 当downloadGroup内任务完成时，将completionBlock块提交到主队列。
    dispatch_group_notify(downloadGroup, dispatch_get_main_queue(), ^{
        if (completionBlock) {
            completionBlock(error);
        }
    });
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
