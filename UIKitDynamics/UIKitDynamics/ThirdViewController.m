//
//  ThirdViewController.m
//  UIKitDynamics
//
//  Created by ad on 22/06/2017.
//
//  详细博文：https://github.com/pro648/tips/wiki/%E4%B8%80%E7%AF%87%E6%96%87%E7%AB%A0%E5%AD%A6%E4%BC%9A%E4%BD%BF%E7%94%A8UIKit%20Dynamics

#import "ThirdViewController.h"

@interface ThirdViewController ()

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIView *redView;
@property (strong, nonatomic) UIView *blueView;
@property (assign, nonatomic) CGRect originalBounds;
@property (assign, nonatomic) CGPoint originalCenter;
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) UIAttachmentBehavior *attachmentBehavior;
@property (strong, nonatomic) UIPushBehavior *pushBehavior;
@property (strong, nonatomic) UIDynamicItemBehavior *itemBehavior;

@end

static CGFloat const ThrowingThreshold = 1000;
static CGFloat const ThrowingVelocityPadding = 15;

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.originalBounds = self.imageView.bounds;
    self.originalCenter = self.imageView.center;
    
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.redView];
    [self.view addSubview:self.blueView];
    
    // 为imageView添加平移手势识别器
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleAttachmentGesture:)];
    [self.imageView addGestureRecognizer:pan];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Properties

- (UIImageView *)imageView {
    if (!_imageView) {
        CGPoint center = self.view.center;
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 240, 240)];
        _imageView.center = CGPointMake(center.x, center.y*2/3);
        _imageView.image = [UIImage imageNamed:@"AppleLogo.jpg"];
        _imageView.userInteractionEnabled = YES;
    }
    return _imageView;
}

- (UIView *)redView {
    if (!_redView) {
        _redView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        _redView.center = CGPointMake(self.view.center.x, self.view.center.y*2/3);
        _redView.backgroundColor = [UIColor redColor];
    }
    return _redView;
}

- (UIView *)blueView {
    if (!_blueView) {
        _blueView = [[UIView alloc] initWithFrame:CGRectMake(80, 400, 10, 10)];
        _blueView.backgroundColor = [UIColor blueColor];
    }
    return _blueView;
}

#pragma mark - IBAction

- (void)handleAttachmentGesture:(UIPanGestureRecognizer *)panGesture {
    CGPoint location = [panGesture locationInView:self.view];
    CGPoint boxLocation = [panGesture locationInView:self.imageView];
    
    switch (panGesture.state) {
        // 手势开始
        case UIGestureRecognizerStateBegan:
//            NSLog(@"Touch started position: %@",NSStringFromCGPoint(location));
//            NSLog(@"Location in image started is %@",NSStringFromCGPoint(boxLocation));
            // 1.如果存在动力行为 则移除所有动力行为
            [self.animator removeAllBehaviors];
            
            // 2.通过改变锚点移动imageView
            UIOffset centerOffset = UIOffsetMake(boxLocation.x - CGRectGetMidX(self.imageView.bounds), boxLocation.y - CGRectGetMidY(self.imageView.bounds));
            self.attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:self.imageView offsetFromCenter:centerOffset attachedToAnchor:location];
            
            // 3.redView中心设置为attachmentBehavior的anchorPoint  blueView的中心设置为手势手势开始的位置
            self.redView.center = self.attachmentBehavior.anchorPoint;
            self.blueView.center = location;
            
            // 4.添加附着行为到animator
            self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
            [self.animator addBehavior:self.attachmentBehavior];
            
            break;
            
        // 手势改变
        case UIGestureRecognizerStateChanged:
            self.attachmentBehavior.anchorPoint = [panGesture locationInView:self.view];
            self.redView.center = self.attachmentBehavior.anchorPoint;
            break;
            
        // 手势结束
        case UIGestureRecognizerStateEnded:
//            NSLog(@"Touch ended position: %@",NSStringFromCGPoint(location));
//            NSLog(@"Location in image ended is %@",NSStringFromCGPoint(boxLocation));
            // 1.移除attachmentBehavior
            [self.animator removeBehavior:self.attachmentBehavior];
            
            // 2.当前运行速度 推动行为力向量大小
            CGPoint velocity = [panGesture velocityInView:self.view];
            CGFloat magnitude = sqrtf(velocity.x * velocity.x + velocity.y * velocity.y);
            
            if (magnitude > ThrowingThreshold) {
                // 3.添加pushBehavior
                UIPushBehavior *pushBehavior = [[UIPushBehavior alloc] initWithItems:@[self.imageView] mode:UIPushBehaviorModeInstantaneous];
                pushBehavior.pushDirection = CGVectorMake(velocity.x / 10, velocity.y / 10);
                pushBehavior.magnitude = magnitude / ThrowingVelocityPadding;
                
                self.pushBehavior = pushBehavior;
                [self.animator addBehavior:self.pushBehavior];
                
                // 4.修改itemBehavior属性 以便让imageView产生飞起来的感觉
                NSInteger angle = arc4random_uniform(20) - 10;
                
                self.itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.imageView]];
                self.itemBehavior.friction = 0.2;
                self.itemBehavior.allowsRotation = YES;
                [self.itemBehavior addAngularVelocity:angle forItem:self.imageView];
                [self.animator addBehavior:self.itemBehavior];
                
                // 5.一定时间后 imageView回到初始位置
                [self performSelector:@selector(resetDemo) withObject:nil afterDelay:0.3];
            }
            else
            {
                [self resetDemo];
            }
            
            break;
            
        default:
            break;
    }
}

- (void)resetDemo {
    [self.animator removeAllBehaviors];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.imageView.bounds = self.originalBounds;
        self.imageView.center = self.originalCenter;
        self.imageView.transform = CGAffineTransformIdentity;
    }];
}

@end
