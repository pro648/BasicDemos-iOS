//
//  TapViewController.m
//  GestureRecognizer
//
//  Created by ad on 19/03/2017.
//
//  demo介绍： https://github.com/pro648/tips/wiki/%E6%89%8B%E5%8A%BF%E6%8E%A7%E5%88%B6%EF%BC%9A%E7%82%B9%E5%87%BB%E3%80%81%E6%BB%91%E5%8A%A8%E3%80%81%E5%B9%B3%E7%A7%BB%E3%80%81%E6%8D%8F%E5%90%88%E3%80%81%E6%97%8B%E8%BD%AC%E3%80%81%E9%95%BF%E6%8C%89%E3%80%81%E8%BD%BB%E6%89%AB

#import "TapViewController.h"

@interface TapViewController ()

@property (strong, nonatomic) IBOutlet UIView *testView;

@end

@implementation TapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 1.1 初始化手势识别器
    UITapGestureRecognizer *singleGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    // 1.2 添加手势识别器
    [self.testView addGestureRecognizer:singleGestureRecognizer];
    
    // 2.1 初始化双击手势
    UITapGestureRecognizer *doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapGesture:)];
    // 2.2 需要两次点击
    doubleTapGestureRecognizer.numberOfTapsRequired = 2;
    // 2.3 添加手势识别器
    [self.testView addGestureRecognizer:doubleTapGestureRecognizer];
    
    // 3 单机手势遇到双击手势时只响应双击手势
    [singleGestureRecognizer requireGestureRecognizerToFail:doubleTapGestureRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark IBAction

- (void)handleSingleTapGesture:(UITapGestureRecognizer *)tapGestureRecognizer
{
    NSLog(@"Single Tap");
    
    /*
    // 使用self.testView
    CGFloat newWidth = 150;
    if (self.testView.frame.size.width == 150)
    {
        newWidth = 300;
    }
    
    CGPoint currentCenter = self.testView.center;
    
    self.testView.frame = CGRectMake(self.testView.frame.origin.x, self.testView.frame.origin.y, newWidth, self.testView.frame.size.height);
    self.testView.center = currentCenter;
    */
     
    // 使用tapGestureRecognizer.view
    CGFloat newWidth = 150;
    if (tapGestureRecognizer.view.frame.size.width == 150)
    {
        newWidth = 300;
    }
    
    CGPoint currentCenter = self.testView.center;
    
    tapGestureRecognizer.view.frame = CGRectMake(tapGestureRecognizer.view.frame.origin.x, tapGestureRecognizer.view.frame.origin.y, newWidth, tapGestureRecognizer.view.frame.size.height);
    tapGestureRecognizer.view.center = currentCenter;
}

- (void)handleDoubleTapGesture:(UITapGestureRecognizer *)tapGestureRecognizer
{
    NSLog(@"Double Tap");
    
    /*
    // 使用self.testView
    CGSize newSize = CGSizeMake(150, 150);
    if (self.testView.frame.size.width == 150)
    {
        newSize.width = 300;
        newSize.height = 300;
    }
    
    CGPoint currentCenter = self.testView.center;
    
    self.testView.frame = CGRectMake(self.testView.frame.origin.x, self.testView.frame.origin.y, newSize.width, newSize.height);
    self.testView.center = currentCenter;
    */
     
    // 使用tapGestureRecognizer.view
    CGSize newSize = CGSizeMake(150, 150);
    if (tapGestureRecognizer.view.frame.size.width == 150)
    {
        newSize.width = 300;
        newSize.height = 300;
    }
    
    CGPoint currentCenter = tapGestureRecognizer.view.center;
    
    tapGestureRecognizer.view.frame = CGRectMake(tapGestureRecognizer.view.frame.origin.x, tapGestureRecognizer.view.frame.origin.y, newSize.width, newSize.height);
    tapGestureRecognizer.view.center = currentCenter;
}

@end
