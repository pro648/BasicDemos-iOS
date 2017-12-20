//
//  ThirdViewController.m
//  Delegation&Notification
//
//  Created by ad on 19/02/2017.
//
//  详细介绍 https://github.com/pro648/tips/wiki/%E5%A7%94%E6%89%98%E3%80%81%E9%80%9A%E7%9F%A5%E4%BC%A0%E5%80%BC%E7%9A%84%E7%94%A8%E6%B3%95%E4%B8%8E%E5%8C%BA%E5%88%AB

#import "ThirdViewController.h"
#import "SecondViewController.h"

@interface ThirdViewController ()

@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) UIButton *backButton;

@end

#define labelWidth self.view.frame.size.width - 32
#define labelHeight 21
NSString *NotificationFromThirdVC = @"NotificationFromThirdVCTextField";

@implementation ThirdViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 添加TextField button
    [self.view addSubview:self.textField];
    [self.view addSubview:self.backButton];
    
    // 设置背景色 标题
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"第三页";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Accessor

- (UITextField *)textField
{
    if (! _textField)
    {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, labelWidth, labelHeight)];
        _textField.center = CGPointMake(self.view.center.x, self.view.center.y - 25);
        
        //  设置占位符颜色
        UIColor *color = [UIColor lightGrayColor];
        _textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入文本后点击上一页 使用通知传值" attributes:@{NSForegroundColorAttributeName:color}];
    }
    
    return _textField;
}

- (UIButton *)backButton
{
    if (! _backButton)
    {
        _backButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _backButton.frame = CGRectMake(0, 0, 80, 30);
        _backButton.center = CGPointMake(self.view.center.x, self.view.center.y + 25);
        [_backButton setTitle:@"上一页" forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backToSecVC:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _backButton;
}

#pragma mark IBAction

- (IBAction)backToSecVC:(UIButton *)sender
{
    // 发送通知
    NSString *string = self.textField.text;
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:string forKey:@"TextField"];
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationFromThirdVC
                                                        object:nil
                                                      userInfo:userInfo];
    
    // 返回SecondViewController
    [self.navigationController popViewControllerAnimated:YES];
}

@end
