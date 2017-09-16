//
//  TimingCurvesViewController.m
//  PropertyAnimator
//
//  Created by ad on 12/09/2017.
//
//  详细介绍：https://github.com/pro648/tips/wiki/UIViewPropertyAnimator%E7%9A%84%E4%BD%BF%E7%94%A8

#import "TimingCurvesViewController.h"

@interface TimingCurvesViewController ()

@property (weak, nonatomic) IBOutlet UIView *redView;
@property (weak, nonatomic) IBOutlet UIView *blueView;
@property (weak, nonatomic) IBOutlet UIView *greenView;
@property (weak, nonatomic) IBOutlet UIView *yellowView;
@property (assign, nonatomic) CGRect redStartFrame;
@property (assign, nonatomic) CGRect blueStartFrame;
@property (assign, nonatomic) CGRect greenStartFrame;
@property (assign, nonatomic) CGRect yellowStartFrame;
@property (strong, nonatomic) UIViewPropertyAnimator *redAnimator;
@property (strong, nonatomic) UIViewPropertyAnimator *blueAnimator;
@property (strong, nonatomic) UIViewPropertyAnimator *greenAnimator;
@property (strong, nonatomic) UIViewPropertyAnimator *yellowAnimator;
@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) NSTimeInterval durationOfAnimation;

@end

CGFloat squareSize = 50;

@implementation TimingCurvesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1.设置UIView初始位置。
    self.redStartFrame = CGRectMake(16, 50, squareSize, squareSize);
    self.blueStartFrame = CGRectMake(16, 150, squareSize, squareSize);
    self.greenStartFrame = CGRectMake(16, 250, squareSize, squareSize);
    self.yellowStartFrame = CGRectMake(16, 350, squareSize, squareSize);
    
    // 2.为durationOfAnimation赋初始值2.0。
    self.durationOfAnimation = 2.0;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // 1.在1.5倍durationOfAnimation时间后，触发动画。
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.durationOfAnimation*1.5 repeats:YES block:^(NSTimer * _Nonnull timer) {
        // 2.动画使用默认时间曲线函数。
        [self startAnimationsWithDefaultCurves];
        
        // 3.使用UICubicTimingParameters。
//        [self startAnimationWithCubicCurves];
        
        // 4.使用UISpringTimingParameters。
//        [self startAnimationWithSpringCurves];
        
        // 启动动画。
        [self.redAnimator startAnimation];
        [self.blueAnimator startAnimation];
        [self.greenAnimator startAnimation];
        [self.yellowAnimator startAnimation];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Default Curves
- (void)startAnimationsWithDefaultCurves {
    // 1.四个视图使用不同类型时间曲线函数。
    self.redAnimator = [self animatorForView:self.redView startFrame:self.redStartFrame curve:UIViewAnimationCurveLinear];
    self.blueAnimator = [self animatorForView:self.blueView startFrame:self.blueStartFrame curve:UIViewAnimationCurveEaseIn];
    self.greenAnimator = [self animatorForView:self.greenView startFrame:self.greenStartFrame curve:UIViewAnimationCurveEaseOut];
    self.yellowAnimator = [self animatorForView:self.yellowView startFrame:self.yellowStartFrame curve:UIViewAnimationCurveEaseInOut];
}

- (UIViewPropertyAnimator *)animatorForView:(UIView *)view startFrame:(CGRect)startFrame curve:(UIViewAnimationCurve)curve {
    // 2.视图初始位置，动画结束时视图位置。
    view.frame = startFrame;
    CGRect finalRect = [self finalRectWithStartFrame:startFrame];
    
    // 3.配置动画。
    UIViewPropertyAnimator *animator = [[UIViewPropertyAnimator alloc] initWithDuration:self.durationOfAnimation curve:curve animations:^{
        view.frame = finalRect;
    }];
    return animator;
}

// UICubicTimingParameters
- (void)startAnimationWithCubicCurves {
    // 1.中间慢，开始、结尾快。
    UICubicTimingParameters *redCubicTimingParameters = [[UICubicTimingParameters alloc] initWithControlPoint1:CGPointMake(0.45, 1.0) controlPoint2:CGPointMake(0.55, 0)];
    // 2.中间快，开始、结尾慢。
    UICubicTimingParameters *blueCubicTimingParameters = [[UICubicTimingParameters alloc] initWithControlPoint1:CGPointMake(1.0, 0.45) controlPoint2:CGPointMake(0, 0.55)];
    self.redAnimator = [self animatorForView:self.redView startFrame:self.redStartFrame timingParameters:redCubicTimingParameters];
    self.blueAnimator = [self animatorForView:self.blueView startFrame:self.blueStartFrame timingParameters:blueCubicTimingParameters];
}

- (UIViewPropertyAnimator *)animatorForView:(UIView *)view startFrame:(CGRect)startFrame timingParameters:(UICubicTimingParameters *)cubicTimingParameters {
    view.frame = startFrame;
    CGRect finalRect = [self finalRectWithStartFrame:startFrame];
    UIViewPropertyAnimator *animator = [[UIViewPropertyAnimator alloc] initWithDuration:self.durationOfAnimation timingParameters:cubicTimingParameters];
    [animator addAnimations:^{
        view.frame = finalRect;
    }];
    return animator;
}

// UISpringTimingParameters
- (void)startAnimationWithSpringCurves {
    // dampingRatio值分别为0.2 1.0 2.0。
    CGFloat underDamped = 0.2;
    CGFloat criticalDamped = 1.0;
    CGFloat overDamped = 2.0;
    self.redAnimator = [self animatorForView:self.redView startFrame:self.redStartFrame dampingRatio:underDamped];
    self.blueAnimator = [self animatorForView:self.blueView startFrame:self.blueStartFrame dampingRatio:criticalDamped];
    self.greenAnimator = [self animatorForView:self.greenView startFrame: self.greenStartFrame dampingRatio:overDamped];
}

- (UIViewPropertyAnimator *)animatorForView:(UIView *)view startFrame:(CGRect)startFrame dampingRatio:(CGFloat)dampingRatio {
    view.frame = startFrame;
    CGRect finalRect = [self finalRectWithStartFrame:startFrame];
    UIViewPropertyAnimator *animator = [[UIViewPropertyAnimator alloc] initWithDuration:self.durationOfAnimation dampingRatio:dampingRatio animations:^{
        view.frame = finalRect;
    }];
    return animator;
}

#pragma mark Help Methods

- (CGRect)finalRectWithStartFrame:(CGRect)startFrame {
    // 4.计算出动画结束时位置。
    CGFloat margin = 16;
    CGFloat screenWidth = CGRectGetWidth(self.view.frame);
    CGFloat finalX = screenWidth - margin - squareSize;
    CGRect finalRect = CGRectMake(finalX, startFrame.origin.y, squareSize, squareSize);
    return finalRect;
}

@end
