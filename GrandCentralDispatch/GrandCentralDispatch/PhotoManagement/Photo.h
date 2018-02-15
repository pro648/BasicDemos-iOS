//
//  Photo.h
//  GrandCentralDispatch
//
//  Created by ad on 07/02/2018.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

static NSString * const kPhotoManagerContentUpdateNotification = @"com.GrandCentralDispatch.PhotoManagerContentUpdate";

typedef void(^PhotoDownloadingCompletionBlock)(UIImage *image, NSError *error);
typedef NS_ENUM(NSInteger, PhotoStatus) {
    PhotoStatusDownloading,
    PhotoStatusGoodToGo,
    PhotoStatusFailed
};

/**
 Photo is a class cluster object that holds the photo data
 @note The Photo class expects you to use one of the predefined init methods instead of the normal init method.
 */
@interface Photo : NSObject

/// Return the PhotoStatus, used to determine if the photo can currently be displayed or not.
@property (nonatomic, readonly, assign) PhotoStatus status;

/// The original image.
- (UIImage *)image;

/// Scaled down image of the original image.
- (UIImage *)thumbnail;

- (instancetype)initWithAsset:(ALAsset *)asset;
- (instancetype)initWithURL:(NSURL *)url;
- (instancetype)initWithURL:(NSURL *)url withCompletionBlock:(PhotoDownloadingCompletionBlock)completionBlock;

@end
