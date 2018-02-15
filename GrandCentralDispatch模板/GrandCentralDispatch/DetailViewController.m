//
//  DetailViewController.m
//  GrandCentralDispatch
//
//  Created by ad on 07/02/2018.
//

#import "DetailViewController.h"
#import <CoreImage/CoreImage.h>
#import <QuartzCore/QuartzCore.h>
#import "PhotoManager.h"

const CGFloat kRetinaToEyeScaleFactor = 0.5f;
const CGFloat kFaceBoundsToEyeScaleFactor = 4.0f;

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation DetailViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageView.image = self.image;
    NSAssert(self.image, @"Image not set; required to use view controller");
    
    UIImage *overlayImage = [self faceOverlayImageFromImage:self.image];
    [self fadeInNewImage:overlayImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

- (UIImage *)faceOverlayImageFromImage:(UIImage *)image {
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                              context:NULL
                                              options:@{CIDetectorAccuracy : CIDetectorAccuracyHigh}];
    // Get features from the image.
    CIImage *newImage = [CIImage imageWithCGImage:image.CGImage];
    
    NSArray *features = [detector featuresInImage:newImage];
    
    UIGraphicsBeginImageContext(image.size);
    CGRect imageRect = CGRectMake(0, 0, image.size.width, image.size.height);
    
    // Draws this in the upper left coordinate system.
    [image drawInRect:imageRect blendMode:kCGBlendModeNormal alpha:1.0];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for (CIFaceFeature *faceFeature in features) {
        CGRect faceRect = [faceFeature bounds];
        CGContextSaveGState(context);
        
        // CI and CG work in different coordinate systems, we should translate to the correct one so we don't get mixed up when calculating the face position.
        CGContextTranslateCTM(context, 0, imageRect.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        
        if ([faceFeature hasLeftEyePosition]) {
            CGPoint leftEyePosition = [faceFeature leftEyePosition];
            CGFloat eyeWidth = faceRect.size.width / kFaceBoundsToEyeScaleFactor;
            CGFloat eyeHeight = faceRect.size.height / kFaceBoundsToEyeScaleFactor;
            CGRect eyeRect = CGRectMake(leftEyePosition.x - eyeWidth/2.0f,
                                        leftEyePosition.y - eyeHeight/2.0f,
                                        eyeWidth,
                                        eyeHeight);
            [self drawEyeBallForFrame:eyeRect];
        }
        
        if ([faceFeature hasRightEyePosition]) {
            CGPoint rightEyePosition = [faceFeature rightEyePosition];
            CGRect eyeRect = [self eyeRectWithFaceRect:faceRect eyePosition:rightEyePosition];
            [self drawEyeBallForFrame:eyeRect];
        }
        
        CGContextRestoreGState(context);
    }
    
    UIImage *overlayImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return overlayImage;
}

- (CGRect)eyeRectWithFaceRect:(CGRect)faceRect eyePosition:(CGPoint)eyePosition {
    CGFloat eyeWidth = faceRect.size.width / kFaceBoundsToEyeScaleFactor;
    CGFloat eyeHeight = faceRect.size.height / kFaceBoundsToEyeScaleFactor;
    CGRect eyeRect = CGRectMake(eyePosition.x - eyeWidth/2.0f,
                                eyePosition.y - eyeHeight/2.0f,
                                eyeWidth,
                                eyeHeight);
    return eyeRect;
}

- (CGFloat)faceRotationInRadiansWithLeftEyePoint:(CGPoint)startPoint rightEyePoint:(CGPoint)endPoint {
    CGFloat deltaX = endPoint.x - startPoint.x;
    CGFloat deltaY = endPoint.y - startPoint.y;
    CGFloat angleInRadians = atan2f(deltaY, deltaX);
    return angleInRadians;
}

- (void)drawEyeBallForFrame:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddEllipseInRect(context, rect);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillPath(context);
    
    CGFloat x, y, eyeSizeWidth, eyeSizeHeight;
    eyeSizeWidth = rect.size.width * kRetinaToEyeScaleFactor;
    eyeSizeHeight = rect.size.height * kRetinaToEyeScaleFactor;
    
    x = arc4random_uniform(rect.size.width - eyeSizeWidth);
    y = arc4random_uniform(rect.size.height - eyeSizeHeight);
    x += rect.origin.x;
    y += rect.origin.y;
    
    CGFloat eyeSize = MIN(eyeSizeWidth, eyeSizeHeight);
    CGRect eyeBallRect = CGRectMake(x, y, eyeSize, eyeSize);
    CGContextAddEllipseInRect(context, eyeBallRect);
    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextFillPath(context);
}

- (void)fadeInNewImage:(UIImage *)newImage {
    UIViewPropertyAnimator *animator = [[UIViewPropertyAnimator alloc] initWithDuration:0.75f
                                                                                  curve:UIViewAnimationCurveLinear
                                                                             animations:^{
                                                                                 self.imageView.image = newImage;
                                                                             }];
    [animator startAnimation];
}

@end
