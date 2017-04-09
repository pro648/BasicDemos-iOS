//
//  ThirdViewController.m
//  StackView
//
//  Created by ad on 07/04/2017.
//
//  demo详细介绍： https://github.com/pro648/tips/wiki/Auto-Layout%E4%B8%ADStack-View%E7%9A%84%E4%BD%BF%E7%94%A8

#import "ThirdViewController.h"

@interface ThirdViewController ()

@property (weak, nonatomic) IBOutlet UIStackView *horizontalStackView;
- (IBAction)addStar:(UIButton *)sender;
- (IBAction)removeStar:(UIButton *)sender;

@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addStar:(UIButton *)sender
{
    UIImageView *filledStarView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"filledStar"]];
    
    // 添加视图到堆栈视图
    [self.horizontalStackView addArrangedSubview:filledStarView];
    filledStarView.contentMode = UIViewContentModeScaleAspectFit;
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.horizontalStackView layoutIfNeeded];
    }];
}

- (IBAction)removeStar:(UIButton *)sender
{
    UIView *filledView = self.horizontalStackView.arrangedSubviews.lastObject;
    
    // 如果视图存在，移除视图
    if (filledView)
    {
        [filledView removeFromSuperview];   // 会自动从arrangedSubviews移除
        [UIView animateWithDuration:0.25 animations:^{
            [self.horizontalStackView layoutIfNeeded];
        }];
    }
}

@end
