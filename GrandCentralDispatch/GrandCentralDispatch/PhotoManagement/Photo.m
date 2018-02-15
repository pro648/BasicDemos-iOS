//
//  Photo.m
//  GrandCentralDispatch
//
//  Created by ad on 07/02/2018.
//

#import "Photo.h"
#import "UIImage+Resize.h"

#pragma mark - Private Class AssetPhoto

@interface __p_AssetPhoto : Photo

@property (nonatomic, strong) ALAsset *asset;

@end

@implementation __p_AssetPhoto

- (UIImage *)thumbnail {
    UIImage *thumbnail = [UIImage imageWithCGImage:[self.asset thumbnail]];
    return thumbnail;
}

- (UIImage *)image {
    ALAssetRepresentation *representation = [self.asset defaultRepresentation];
    UIImage *image = [UIImage imageWithCGImage:[representation fullScreenImage]];
    return image;
}

- (PhotoStatus)status {
    return PhotoStatusGoodToGo;
}

@end

#pragma mark - Private Class DownloadPhoto

@interface __P_DownloadPhoto : Photo

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) UIImage *thumbnail;

@end

@implementation __P_DownloadPhoto
@synthesize status = _status;

- (void)downloadImageWithCompletion:(PhotoDownloadingCompletionBlock)completionBlock {
    static NSURLSession *session;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        session = [NSURLSession sessionWithConfiguration:configuration];
    });
    NSURLSessionDataTask *task = [session dataTaskWithURL:self.url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        self.image = [UIImage imageWithData:data];
        if (!error && _image) {
            _status = PhotoStatusGoodToGo;
        } else {
            _status = PhotoStatusFailed;
        }
        
        self.thumbnail = [_image thumbnailImage:64
                              transparentBorder:0 cornerRadius:0 interpolationQuality:kCGInterpolationDefault];
        
        if (completionBlock) {
            completionBlock(_image, error);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            NSNotification *notification = [NSNotification notificationWithName:kPhotoManagerContentUpdateNotification object:nil];
            [[NSNotificationQueue defaultQueue] enqueueNotification:notification postingStyle:NSPostASAP coalesceMask:NSNotificationCoalescingOnName forModes:NULL];
        });
    }];
    
    [task resume];
}

- (UIImage *)thumbnail {
    return _thumbnail;
}

- (UIImage *)image {
    return _image;
}

- (PhotoStatus)status {
    return _status;
}

@end

#pragma mark - Public Class Photo

@interface Photo()

@property (nonatomic, assign) PhotoStatus status;   // Redeclare status as writeable.

@end

@implementation Photo

- (instancetype)initWithAsset:(ALAsset *)asset {
    NSAssert(asset, @"Asset is nil");
    __p_AssetPhoto *assetPhoto;
    assetPhoto = [[__p_AssetPhoto alloc] init];
    if (assetPhoto) {
        assetPhoto.asset = asset;
        assetPhoto.status = PhotoStatusGoodToGo;
    }
    return assetPhoto;
}

- (instancetype)initWithURL:(NSURL *)url {
    NSAssert(url, @"url is nil");
    __P_DownloadPhoto *downloadPhoto;
    downloadPhoto = [[__P_DownloadPhoto alloc] init];
    if (downloadPhoto) {
        downloadPhoto.status = PhotoStatusDownloading;
        downloadPhoto.url = url;
        [downloadPhoto downloadImageWithCompletion:nil];
    }
    return downloadPhoto;
}

- (instancetype)initWithURL:(NSURL *)url withCompletionBlock:(PhotoDownloadingCompletionBlock)completionBlock {
    NSAssert(url, @"URL is nil");
    __P_DownloadPhoto *downloadPhoto;
    downloadPhoto = [[__P_DownloadPhoto alloc] init];
    if (downloadPhoto) {
        downloadPhoto.status = PhotoStatusDownloading;
        downloadPhoto.url = url;
        [downloadPhoto downloadImageWithCompletion:[completionBlock copy]];
    }
    return downloadPhoto;
}

#pragma mark - Don't use these in the abstract base class! I am cereal!

- (PhotoStatus)status {
    NSAssert(NO, @"Use One of Photo's public initializer methods");
    return PhotoStatusFailed;
}

- (UIImage *)image {
    NSAssert(NO, @"Use one of Photo's public initializer methods");
    return nil;
}

- (UIImage *)thumbnail {
    NSAssert(NO, @"Use one of Photo's public initializer methods");
    return nil;
}

@end
