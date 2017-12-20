//
//  ViewController.m
//  Delegation&Notification
//
//  Created by ad on 19/02/2017.
//
//  详细介绍 https://github.com/pro648/tips/wiki/%E5%A7%94%E6%89%98%E3%80%81%E9%80%9A%E7%9F%A5%E4%BC%A0%E5%80%BC%E7%9A%84%E7%94%A8%E6%B3%95%E4%B8%8E%E5%8C%BA%E5%88%AB

#import "ViewController.h"
#import "SecondViewController.h"

@interface ViewController ()

@property (strong, nonatomic) UILabel *notiLabel;
@property (strong, nonatomic) UILabel *deleLabel;
@property (strong, nonatomic) UIButton *button;

@end

#define labelWidth self.view.frame.size.width - 32
#define labelHeight 21

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加label button
    [self.view addSubview:self.deleLabel];
    [self.view addSubview:self.notiLabel];
    [self.view addSubview:self.button];
    
    // 设置背景色 标题
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"首页";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Accessor

- (UILabel *)notiLabel
{
    if (! _notiLabel)
    {
        _notiLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, labelWidth, labelHeight)];
        _notiLabel.center = CGPointMake(self.view.center.x, self.view.center.y - 50);
        _notiLabel.textAlignment = NSTextAlignmentCenter;
        _notiLabel.text = @"显示通知传值";
    }
    
    return _notiLabel;
}

- (UILabel *)deleLabel
{
    if (! _deleLabel)
    {
        _deleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, labelWidth, labelHeight)];
        _deleLabel.center = self.view.center;
        _deleLabel.textAlignment = NSTextAlignmentCenter;
        _deleLabel.text = @"显示委托传值";
    }
    
    return _deleLabel;
}

- (UIButton *)button
{
    if (! _button)
    {
        _button = [UIButton buttonWithType:UIButtonTypeSystem];
        _button.bounds = CGRectMake(0, 0, 80, 30);
        _button.center = CGPointMake(self.view.center.x, self.view.center.y + 50);
        [_button setTitle:@"下一页" forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(goToSecondVC:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _button;
}

#pragma mark IBAction 

- (void)goToSecondVC:(UIButton *)sender
{
    // 跳转到SecondViewController
    SecondViewController *secVC = [[SecondViewController alloc] init];
    [self.navigationController pushViewController:secVC animated:YES];
}

@end
