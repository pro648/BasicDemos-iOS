//
//  ViewController.m
//  Block
//
//  Created by ad on 08/06/2017.
//
//  详细博文介绍：https://github.com/pro648/tips/wiki/Block%E7%9A%84%E7%94%A8%E6%B3%95

#import "ViewController.h"
#import "Handler.h"

@interface ViewController ()

@property (copy) void (^myBlock)(void);

@end

//static int age = 20;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    /*
    // 块的声明
    int (^firstBlock)(NSString *param1, int param2);    // 返回类型为int 参数1为NSString类型 参数2为int类型
    void (^showName)(NSString *pro648);                 // 无返回内容 参数为NSString类型
    void (^allVoid)(void);                              // 无返回内容 不传递参数
    NSDate *(^whatDayIsIt)(void);                       // 返回类型为NSDate 不传递参数
    NSString *(^composeName)(NSString *, NSString *);   // 返回类型为NSString 两个参数均为NSString类型 参数名称可以省略
    */
    
    // 1 声明块
    double (^multiplyTwoValues)(double, double);
    // 2 赋值
    multiplyTwoValues = ^(double firstValue, double secondValue){
        return firstValue * secondValue;
    };
    /* 块声明、赋值合并在一起
    double (^multiplyTwoValues)(double, double) = ^(double firstValue, double secondValue){
        return firstValue * secondValue;
    };
    */
    // 3 调用块
    NSLog(@"multiplyTwoValues %f",multiplyTwoValues(1.1, 2));
    
    [self testBlockStorageType];
    
    Handler *handler = [[Handler alloc] init];
    [handler addNumber:3 withNumber:5 andCompletionHandler:^(int result) {
        NSLog(@"handler %i",result);
    }];
}

- (void)testBlockStorageType{
    __block int anInteger = 648;
    
    // 用块获取局部变量的值
    void (^myOperation)(void) = ^(void){
        NSLog(@"Integer is %i",anInteger);
        anInteger = 100;
    };
    
//    anInteger = 64;
    myOperation();
    NSLog(@"Value of original varialbe is now: %i",anInteger);
    
    // 获取全局变量
    void (^globalTest)(void) = ^(void){
        NSLog(@"gGlobalVar is: %i",gGlobalVar);
        gGlobalVar = 3;
    };
    gGlobalVar = 7;
    globalTest();
    NSLog(@"Value of original gGlobalVar is: %i",gGlobalVar);
}

- (void)configureMyBlock{
//    self.myBlock = ^{
//        [self doSomething];     // Capturing a strong reference to self
//                                // Create a strong reference cycle
//    };
    
    ViewController * __weak weakSelf = self;
    self.myBlock = ^{
        [weakSelf doSomething]; // Capture the weak reference to avoid the reference cycle
    };
}

- (void)doSomething{
    // do something
}

@end
