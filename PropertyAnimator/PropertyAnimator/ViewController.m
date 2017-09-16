//
//  ViewController.m
//  PropertyAnimator
//
//  Created by ad on 27/08/2017.
//
//  详细介绍：https://github.com/pro648/tips/wiki/UIViewPropertyAnimator%E7%9A%84%E4%BD%BF%E7%94%A8

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIView *redView;
@property (weak, nonatomic) IBOutlet UIButton *restartButton;
@property (weak, nonatomic) IBOutlet UIButton *startStopButton;
@property (weak, nonatomic) IBOutlet UIButton *pauseButton;
@property (weak, nonatomic) IBOutlet UISwitch *reverseAnimationSwitch;
@property (weak, nonatomic) IBOutlet UIStepper *durationStepper;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (strong, nonatomic) UIViewPropertyAnimator *propertyAnimator;
@property (assign, nonatomic) NSTimeInterval duration;
@property (assign, nonatomic) CGRect startFrame;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置startFrame位置，pauseButton状态。
    self.startFrame = CGRectMake(16, 45, 100, 100);
    self.pauseButton.enabled = NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupAnimator {
    // 1.动画初始位置。
    self.redView.frame = self.startFrame;
    
    // 2.动画终点位置。
    CGFloat margin = 16.0;
    CGFloat screenWidth = CGRectGetWidth(self.view.frame);
    CGFloat finalX = screenWidth - CGRectGetWidth(self.redView.frame) - margin;
    CGRect finalRect = CGRectMake(finalX, self.redView.frame.origin.y, self.redView.frame.size.width, self.redView.frame.size.height);
    
    // 3.初始化动画。
    self.propertyAnimator = [[UIViewPropertyAnimator alloc] initWithDuration:self.duration
                                                                       curve:UIViewAnimationCurveEaseIn
                                                                  animations:^{
                                                                      self.redView.frame = finalRect;
                                                                  }];
    
    // 4.为动画添加完成块。
    ViewController * __weak weakSelf = self;
    ViewController *vc = weakSelf;
    if (vc) {
        [self.propertyAnimator addCompletion:^(UIViewAnimatingPosition finalPosition) {
            [vc.startStopButton setTitle:@"Start" forState:UIControlStateNormal];
            vc.startStopButton.enabled = NO;
            vc.pauseButton.enabled = NO;
            vc.restartButton.enabled = YES;
        }];
    }
    vc = nil;
}

- (IBAction)stepperValueChanged:(UIStepper *)sender {
    // 1.设置动画持续时间为UIStpper的值。
    self.duration = sender.value;
    
    // 2.同步更新到label。
    self.durationLabel.text = [NSString stringWithFormat:@"%.1f",sender.value];
}

- (IBAction)startStopPause:(UIButton *)sender {
    // 1.禁用restartButton，propertyAnimator不存在时，配置propertyAnimator。
    self.restartButton.enabled = NO;
    if (!self.propertyAnimator) {
        [self setupAnimator];
    }
    
    if (sender == self.pauseButton) {
        // 2.点击Pause按钮时，根据当前动画状态更新视图。
        self.propertyAnimator.isRunning ? [self.propertyAnimator pauseAnimation] : [self.propertyAnimator startAnimation];
        NSString *title = self.propertyAnimator.isRunning ? @"Pause" : @"Unpause";
        [self.pauseButton setTitle:title forState:UIControlStateNormal];
        self.startStopButton.enabled = self.propertyAnimator.isRunning;
    }
    else
    {
        // 3.点击Start按钮时，根据当前动画状态更新视图。
        switch (self.propertyAnimator.state) {
            case UIViewAnimatingStateInactive:
                [self.propertyAnimator startAnimation];
                [self.startStopButton setTitle:@"Stop" forState:UIControlStateNormal];
                self.pauseButton.enabled = YES;
                NSLog(@"UIViewAnimatingStateInactive");
                break;
                
            case UIViewAnimatingStateActive:
                if (self.propertyAnimator.isRunning) {
                    [self.propertyAnimator stopAnimation:NO];
                    [self.propertyAnimator finishAnimationAtPosition:UIViewAnimatingPositionCurrent];
                    [self.startStopButton setTitle:@"Start" forState:UIControlStateNormal];
                    self.pauseButton.enabled = NO;
                }
                else
                {
                    [self.propertyAnimator startAnimation];
                    [self.startStopButton setTitle:@"Stop" forState:UIControlStateNormal];
                    self.pauseButton.enabled = YES;
                }
                NSLog(@"UIViewAnimatingStateActive");
                break;
                
            case UIViewAnimatingStateStopped:
                NSLog(@"UIViewAnimatingStateStopped");
                break;
                
            default:
                break;
        }
    }
}

- (IBAction)reverseAnimationSwitchValueChanged:(UISwitch *)sender {
    if (self.propertyAnimator && self.propertyAnimator.isRunning) {
        // 在propertyAnimator存在，且正在运行时，根据UISwitch的值调整propertyAnimator的方向。
        self.propertyAnimator.reversed = sender.isOn;
    }
}

- (IBAction)restartAnimation:(UIButton *)sender {
    // 点击RestartAnimation按钮时，重新配置动画，启用Start按钮，将reverseAnimationSwitch设置为关闭状态。
    [self setupAnimator];
    self.startStopButton.enabled = YES;
    self.reverseAnimationSwitch.on = NO;
}

- (IBAction)scrubAnimation:(UISlider *)sender {
    if (!self.propertyAnimator) {
        [self setupAnimator];
    }
    
    // 1.当propertyAnimator正在运行时，暂停该动画，否则在停止拖动UISlider后，动画会继续运行。
    if (self.propertyAnimator.isRunning) {
        [self.propertyAnimator pauseAnimation];
    }
    
    // 2.设置动画百分比。
    self.propertyAnimator.fractionComplete = sender.value;
}






@end
