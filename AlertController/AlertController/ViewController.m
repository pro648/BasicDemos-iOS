//
//  ViewController.m
//  AlertController
//
//  Created by ad on 10/03/2017.
//
//  详细介绍： https://github.com/pro648/tips/wiki/UIAlertController%E7%9A%84%E4%BD%BF%E7%94%A8

#import "ViewController.h"

@interface ViewController ()

- (IBAction)showAlertView:(UIButton *)sender;
- (IBAction)showLoginAlertView:(UIButton *)sender;
- (IBAction)showActionSheet:(UIButton *)sender;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // app进入后台后隐藏警报控制器
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidEnterBackgroundNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification * _Nonnull note) {
        [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (void)dealloc
{
    // 移除观察者
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark IBAction

- (IBAction)showAlertView:(UIButton *)sender
{
    // 1.创建UIAlertController
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert Title"
                                                                             message:@"The message is ..."
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    // 2.创建并添加按钮
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"OK Action");
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Cancel Action");
    }];
    UIAlertAction *resetAction = [UIAlertAction actionWithTitle:@"Reset" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Reset Action");
    }];
    
    [alertController addAction:cancelAction];       // B
    [alertController addAction:okAction];           // A
    [alertController addAction:resetAction];        // C
    
    // 3.呈现`UIAlertContorller`
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)showLoginAlertView:(UIButton *)sender
{
    // 1.创建UIAlertController
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Login"
                                                                             message:@"Enter Your Account Info Below"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    // 2.1 添加文本框
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"username";
        
        [textField addTarget:self action:@selector(alertUserNameDidChange:) forControlEvents:UIControlEventEditingChanged];     // 添加响应事件
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"password";
        textField.secureTextEntry = YES;
        
        [textField addTarget:self action:@selector(alertPasswordDidChange:) forControlEvents:UIControlEventEditingChanged];     // 添加响应事件
    }];
    
    // 2.2  创建Cancel Login按钮
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Cancel Action");
    }];
    UIAlertAction *loginAction = [UIAlertAction actionWithTitle:@"Login" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *userName = alertController.textFields.firstObject;
        UITextField *password = alertController.textFields.lastObject;
        
        // 输出用户名 密码到控制台
        NSLog(@"username is %@, password is %@",userName.text,password.text);
    }];
    
    // 2.3 添加按钮
    loginAction.enabled = NO;   // 禁用Login按钮
    [alertController addAction:cancelAction];
    [alertController addAction:loginAction];
    
    // 3.显示警报控制器
    [self presentViewController:alertController animated:YES completion:nil];
}


- (IBAction)showActionSheet:(UIButton *)sender
{
    // 1.创建UIAlertController
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Action Sheet"
                                                                             message:@"Deleted data can't be restored"
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    
    // 2.1 创建按钮
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Delete Action");
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Cancel Action");
    }];
    
    // 2.2 添加按钮
    [alertController addAction:deleteAction];
    [alertController addAction:cancelAction];
    
    UIPopoverPresentationController *popover = alertController.popoverPresentationController;
    if (popover)
    {
        popover.sourceView = sender;
        popover.sourceRect = sender.bounds;
        popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
    }
    
    // 3.显示警报控制器
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark -
#pragma mark IBAction

- (void)alertUserNameDidChange:(UITextField *)sender
{
    UIAlertController *alertController = (UIAlertController *)self.presentedViewController;
    
    if (alertController)
    {
        UITextField *userName = alertController.textFields.firstObject;
        UIAlertAction *loginAction = alertController.actions.lastObject;
        loginAction.enabled = userName.text.length > 3;     // 用户名必须大于三位
    }
}

- (void)alertPasswordDidChange:(UITextField *)sender
{
    UIAlertController *alertController = (UIAlertController *)self.presentedViewController;
    
    if (alertController)
    {
        UITextField *password = alertController.textFields.lastObject;
        UIAlertAction *loginAction = alertController.actions.lastObject;
        loginAction.enabled = password.text.length > 6;     // 密码必须大于六位
    }
}

@end
