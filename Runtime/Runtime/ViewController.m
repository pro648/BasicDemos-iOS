//
//  ViewController.m
//  Runtime
//
//  Created by pro648 on 2020/3/7.
//  Copyright © 2020 pro648. All rights reserved.
//
//  详细介绍：https://github.com/pro648/tips/wiki/Runtime%E4%BB%8E%E5%85%A5%E9%97%A8%E5%88%B0%E8%BF%9B%E9%98%B6%E4%B8%80
//  https://github.com/pro648/tips/wiki/Runtime%E4%BB%8E%E5%85%A5%E9%97%A8%E5%88%B0%E8%BF%9B%E9%98%B6%E4%BA%8C

#import "ViewController.h"
#import "Engineer.h"
#import "PremiumUser.h"
#import "UIView+DefaultColor.h"
#import "AllocateClass.h"
#import <objc/runtime.h>
#import "Safari.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    Engineer *engineer = [[Engineer alloc] initWithName:@"pro648"];
//
//    [engineer sayHi];
//    // compiler translates above line to:
//    objc_msgSend(engineer, @selector(sayHi));
    
    // 查看isa、super_class指针指向
//    [engineer testMetaClass];
//    [engineer testSuperClass];
    
    // 动态方法解析
//    [engineer run];
    
    // 实例方法 转发
//    int days = [engineer numberOfDaysInMonth:3];
    // 类方法 转发
//    int days = [Engineer numberOfDaysInMonth:3];
    
//    [self testTypeEncodings];
    
    // 交换方法
//    [self testExchangeImp];
    
    // Method Swizzling
//    [self testMethodSwizzling];
    
    // Associated Objects
//    [self testAssociatedObjects];
    
    // 创建类
//    [self testCreateClass];
    
    // 获取私有成员变量
//    [self testPrivateIvar];
    
    // super superclass
//    [self testSuperSuperClass];
}

- (void)testTypeEncodings {
    char *intTypeCode = @encode(int);
    char *voidTypeCode = @encode(void);
    
    NSLog(@"int: %s, void:%s",intTypeCode, voidTypeCode);
}

// MARK: - Exchange Implementation
- (void)testExchangeImp {
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSMutableArray *array = [NSMutableArray array];
            [array addObject:@"1"];
            
            NSString *name = nil;
        //    [array insertObject:@"bbb" atIndex:4];
            [array addObject:name];
    });
    
    NSLog(@"");
}

/// Method Swizzling
- (void)testMethodSwizzling {
    // 如果直接使用 method_exchangeImplementations(),调用父类的happyBirthday会闪退。
    User *user = [[User alloc] init];
    [user happyBirthday];
    
//    PremiumUser *premium = [[PremiumUser alloc] init];
//    [premium happyBirthday];
    
//    User *user = [[User alloc] init];
//    [user happyBirthday];
}

/// Associated Objects
- (void)testAssociatedObjects {
    UIView *view = [[UIView alloc] init];
    view.defaultColor = [UIColor orangeColor];
    NSLog(@"%@", view.defaultColor);
}

/// 创建Class、ivar
- (void)testCreateClass {
    __unused AllocateClass *cls = [[AllocateClass alloc] init];
}

/// 查看UITextField占位符私有成员变量
- (void)testPrivateIvar {
    self.textField.placeholder = @"github.com/pro648";
    
    unsigned int count;
    Ivar *ivars = class_copyIvarList(self.textField.class, &count);
    for (int i=0; i<count; ++i) {
        Ivar ivar = ivars[i];
        NSLog(@"%s %s", ivar_getName(ivar), ivar_getTypeEncoding(ivar));
    }
    free(ivars);
    
    id placeholderLabel = [self.textField valueForKeyPath:@"placeholderLabel"];
    if ([placeholderLabel isKindOfClass:UILabel.class]) {
        UILabel *label = (UILabel *)placeholderLabel;
        label.textColor = [UIColor redColor];
    }
}

/// super superclass
- (void)testSuperSuperClass {
    Safari *sa = [[Safari alloc] init];
}

@end
