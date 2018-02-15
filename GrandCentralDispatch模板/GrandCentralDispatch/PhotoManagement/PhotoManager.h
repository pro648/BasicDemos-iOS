//
//  PhotoManager.h
//  GrandCentralDispatch
//
//  Created by ad on 07/02/2018.
//

#import <Foundation/Foundation.h>
#import "Photo.h"

typedef void (^PhotoProcessingProgressBlock)(CGFloat completionPercentage);
typedef void (^BatchPhotoDownloadingCompletionBlock)(NSError *error);

static NSString * const kPhotoManagerAddedContentNotification = @"com.GrandCentralDispatch.PhotoManagerAddedContent";

/**
 PhotoManager is designed for singleton use to manage all the Photo instances the user selects.
 */
@interface PhotoManager : NSObject

+(instancetype)sharedManager;

/// Warning this is not currently thread safe.
- (NSArray *)photos;

/// Warning this is not currently thread safe.
- (void)addPhoto:(Photo *)photo;

/// Warning the completion block gets fired too soon.
- (void)downloadPhotosWithCompletionBlock:(BatchPhotoDownloadingCompletionBlock)completionBlock;

@end
