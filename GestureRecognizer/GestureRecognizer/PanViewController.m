//
//  PanViewController.m
//  GestureRecognizer
//
//  Created by ad on 19/03/2017.
//
//

#import "PanViewController.h"

@interface PanViewController ()

@property (strong, nonatomic) IBOutlet UIView *testView;
@property (strong, nonatomic) IBOutlet UILabel *horizontalVelocityLabel;
@property (strong, nonatomic) IBOutlet UILabel *verticalVelocityLabel;

@end

@implementation PanViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveViewWithGestureRecognizer:)];
    [self.testView addGestureRecognizer:panGestureRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark IBAction

- (void)moveViewWithGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer
{
    NSLog(@"Pan Tap");
    
    CGPoint touchPoint = [panGestureRecognizer locationInView:self.view];
    
//    self.testView.center = touchPoint;
    panGestureRecognizer.view.center = touchPoint;
    
    // 获取移动速度并显示到标签
    CGPoint velocity = [panGestureRecognizer velocityInView:self.view];
    
    self.horizontalVelocityLabel.text = [NSString stringWithFormat:@"Horizontal Velocity: %.2f points/sec",velocity.x]; // x轴速度
    self.verticalVelocityLabel.text = [NSString stringWithFormat:@"Vertical Velocity: %.2f points/sec",velocity.y]; // y轴速度
}

@end
