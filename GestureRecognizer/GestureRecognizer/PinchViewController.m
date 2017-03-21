//
//  PinchViewController.m
//  GestureRecognizer
//
//  Created by ad on 19/03/2017.
//
//

#import "PinchViewController.h"

@interface PinchViewController ()

@property (strong, nonatomic) IBOutlet UIView *testView;

@end

@implementation PinchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchWithGestureRecognizer:)];
    [self.testView addGestureRecognizer:pinchGestureRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark IBAction

- (void)handlePinchWithGestureRecognizer:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    NSLog(@"Pinch Gesture");
    
    pinchGestureRecognizer.view.transform = CGAffineTransformScale(pinchGestureRecognizer.view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
    pinchGestureRecognizer.scale = 1.0;     // 重设scale
}

@end
