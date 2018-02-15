//
//  UIImage+Alpha.h
//  GrandCentralDispatch
//
//  Created by ad on 07/02/2018.
//

#import <UIKit/UIKit.h>

// Helper methods for adding an alpha layer to an image.
@interface UIImage (Alpha)

- (BOOL)hasAlpha;
- (UIImage *)imageWithAlpha;
- (UIImage *)transparentBorderImage:(NSUInteger)borderSize;
- (CGImageRef)newBorderMask:(NSUInteger)borderSize size:(CGSize)size;

@end
