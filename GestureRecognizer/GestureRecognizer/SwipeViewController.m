//
//  SwipeViewController.m
//  GestureRecognizer
//
//  Created by ad on 19/03/2017.
//
//  demo介绍： https://github.com/pro648/tips/wiki/%E6%89%8B%E5%8A%BF%E6%8E%A7%E5%88%B6%EF%BC%9A%E7%82%B9%E5%87%BB%E3%80%81%E6%BB%91%E5%8A%A8%E3%80%81%E5%B9%B3%E7%A7%BB%E3%80%81%E6%8D%8F%E5%90%88%E3%80%81%E6%97%8B%E8%BD%AC%E3%80%81%E9%95%BF%E6%8C%89%E3%80%81%E8%BD%BB%E6%89%AB

#import "SwipeViewController.h"

@interface SwipeViewController ()

@property (strong, nonatomic) IBOutlet UIView *viewOrange;
@property (strong, nonatomic) IBOutlet UIView *viewBlack;
@property (strong, nonatomic) IBOutlet UIView *viewRed;

@end

@implementation SwipeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 初始化滑动手势识别器 滑动方向为右滑 添加到viewOrange
    UISwipeGestureRecognizer *swipeRightOrange = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(slideToRightWithGestureRecognizer:)];
    swipeRightOrange.direction = UISwipeGestureRecognizerDirectionRight;
    [self.viewOrange addGestureRecognizer:swipeRightOrange];
    
    // 初始化滑动手势识别器 滑动方向为左滑 添加到viewOrange
    UISwipeGestureRecognizer *swipeLeftOrange = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(slideToLeftWithGestureRecognizer:)];
    swipeLeftOrange.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.viewOrange addGestureRecognizer:swipeLeftOrange];
    
    // viewRed添加左滑手势识别器
    UISwipeGestureRecognizer *swipeLeftRed = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(slideToLeftWithGestureRecognizer:)];
    swipeLeftRed.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.viewRed addGestureRecognizer:swipeLeftRed];
    
    // viewBlack添加右滑手势识别器
    UISwipeGestureRecognizer *swipeRightBlack = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(slideToRightWithGestureRecognizer:)];
    swipeRightBlack.direction = UISwipeGestureRecognizerDirectionRight;
    [self.viewBlack addGestureRecognizer:swipeRightBlack];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark IBAction

- (void)slideToRightWithGestureRecognizer:(UISwipeGestureRecognizer *)swipeGestureRecognizer
{
    NSLog(@"Swipe Right");
    
    CGFloat viewWidth = self.view.frame.size.width;
    
    // 右移
    [UIView animateWithDuration:0.5 animations:^{
        self.viewOrange.frame = CGRectOffset(self.viewOrange.frame, viewWidth, 0);
        self.viewBlack.frame = CGRectOffset(self.viewBlack.frame, viewWidth, 0);
        self.viewRed.frame = CGRectOffset(self.viewRed.frame, viewWidth, 0);
    }];
}

- (void)slideToLeftWithGestureRecognizer:(UISwipeGestureRecognizer *)swipeGestureRecognizer
{
    NSLog(@"Swipe Left");
    
    CGFloat viewWidth = self.view.frame.size.width;
    
    // 左移
    [UIView animateWithDuration:0.5 animations:^{
        self.viewOrange.frame = CGRectOffset(self.viewOrange.frame, -viewWidth, 0);
        self.viewBlack.frame = CGRectOffset(self.viewBlack.frame, -viewWidth, 0);
        self.viewRed.frame = CGRectOffset(self.viewRed.frame, -viewWidth, 0);
    }];
}

@end
