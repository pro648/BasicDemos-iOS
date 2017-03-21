//
//  RotationViewController.m
//  GestureRecognizer
//
//  Created by ad on 19/03/2017.
//
//

#import "RotationViewController.h"

@interface RotationViewController ()

@property (strong, nonatomic) IBOutlet UIView *testView;

@end

@implementation RotationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIRotationGestureRecognizer *rotationGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotationWithGestureRecognizer:)];
    [self.testView addGestureRecognizer:rotationGestureRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark IBAction

- (void)handleRotationWithGestureRecognizer:(UIRotationGestureRecognizer *)rotationGestureRecognizer
{
    NSLog(@"Rotation Gesture");
    
    rotationGestureRecognizer.view.transform = CGAffineTransformRotate(rotationGestureRecognizer.view.transform, rotationGestureRecognizer.rotation);
    rotationGestureRecognizer.rotation = 0.0;
}


@end
