//
//  FirstViewController.m
//  StackView
//
//  Created by ad on 07/04/2017.
//
//  demo详细介绍： https://github.com/pro648/tips/wiki/Auto-Layout%E4%B8%ADStack-View%E7%9A%84%E4%BD%BF%E7%94%A8

#import "FirstViewController.h"

@interface FirstViewController ()

- (IBAction)axisChange:(UISwitch *)sender;
@property (weak, nonatomic) IBOutlet UIStackView *imageStackView;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)axisChange:(UISwitch *)sender
{
    [UIView animateWithDuration:0.25 animations:^{
        [self updateConstraintsForAxis];
    }];
}

- (void)updateConstraintsForAxis
{
    // 在水平、垂直堆栈视图间切换
    if (self.imageStackView.axis == UILayoutConstraintAxisHorizontal)
    {
        self.imageStackView.axis = UILayoutConstraintAxisVertical;
    }
    else
    {
        self.imageStackView.axis = UILayoutConstraintAxisHorizontal;
    }
}

@end
