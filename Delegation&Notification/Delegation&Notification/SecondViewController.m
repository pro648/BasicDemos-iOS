//
//  SecondViewController.m
//  Delegation&Notification
//
//  Created by ad on 19/02/2017.
//
//  详细介绍 https://github.com/pro648/tips/wiki/%E5%A7%94%E6%89%98%E3%80%81%E9%80%9A%E7%9F%A5%E4%BC%A0%E5%80%BC%E7%9A%84%E7%94%A8%E6%B3%95%E4%B8%8E%E5%8C%BA%E5%88%AB

#import "SecondViewController.h"
#import "ThirdViewController.h"

@interface SecondViewController ()

@property (strong, nonatomic) UILabel *notiLabel;
@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) UIButton *nextButton;

@end

#define labelWidth self.view.frame.size.width - 32
#define labelHeight 21
extern NSString *NotificationFromThirdVC;

@implementation SecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 添加label button textField
    [self.view addSubview:self.notiLabel];
    [self.view addSubview:self.textField];
    [self.view addSubview:self.backButton];
    [self.view addSubview:self.nextButton];
    
    // 设置背景色 标题
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"第二页";
    
    // 添加观察者
    [[NSNotificationCenter defaultCenter] addObserverForName:NotificationFromThirdVC
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification * _Nonnull note) {
          if ([note.name isEqualToString:NotificationFromThirdVC]) {
              // 把通知传送的字符串显示到notiLabel。
              NSDictionary *userInfo = [note userInfo];
              self.notiLabel.text = [userInfo valueForKey:@"TextField"];
          }
                                                  }];
}

- (void)dealloc {
    // 移除观察者。
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NotificationFromThirdVC
                                                  object:nil];
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
        _textField.center =self.view.center;
        _textField.borderStyle = UITextBorderStyleRoundedRect;
        
        // 设置占位符颜色
        UIColor *color = [UIColor lightGrayColor];
        _textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入文本后点击回首页 使用委托传值" attributes:@{NSForegroundColorAttributeName:color}];
    }
    
    return _textField;
}

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

- (UIButton *)backButton
{
    if (! _backButton)
    {
        _backButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _backButton.frame = CGRectMake(0, 0, 80, 30);
        _backButton.center = CGPointMake(self.view.center.x - 60, self.view.center.y + 50);
        [_backButton setTitle:@"回首页" forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backToVC:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _backButton;
}

- (UIButton *)nextButton
{
    if (! _nextButton)
    {
        _nextButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _nextButton.frame = CGRectMake(0, 0, 80, 30);
        _nextButton.center = CGPointMake(self.view.center.x + 60, self.view.center.y + 50);
        [_nextButton setTitle:@"下一页" forState:UIControlStateNormal];
        [_nextButton addTarget:self action:@selector(goToThirdVC:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _nextButton;
}

#pragma mark IBAction

- (IBAction)backToVC:(UIButton *)sender
{
    // 判断是否实现了协议方法
    if ([self.delegate respondsToSelector:@selector(sendText:)])
    {
        // 代理实现了协议方法，传送TextField内文本给代理
        [self.delegate sendText:self.textField.text];
    }
    else
    {
        NSLog(@"代理没有实现协议方法，%d, %s",__LINE__, __PRETTY_FUNCTION__);
    }
    
    // 返回ViewController
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)goToThirdVC:(UIButton *)sender
{
    // 跳转到ThirdViewController
    ThirdViewController *thirdVC = [[ThirdViewController alloc] init];
    [self.navigationController pushViewController:thirdVC animated:YES];
}

@end
