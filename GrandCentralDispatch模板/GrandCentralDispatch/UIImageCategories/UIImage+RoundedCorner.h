//
//  UIImage+RoundedCorner.h
//  GrandCentralDispatch
//
//  Created by ad on 07/02/2018.
//

#import <UIKit/UIKit.h>

// Extends the UIImage class to support making rounded corners.
@interface UIImage (RoundedCorner)

- (UIImage *)roundedCornerImage:(NSInteger)cornerSize borderSize:(NSInteger)borderSize;
- (void)addRoundedRectToPath:(CGRect)rect context:(CGContextRef)context ovalWidth:(CGFloat)ovalWidth ovalHeight:(CGFloat)ovalHeight;

@end
