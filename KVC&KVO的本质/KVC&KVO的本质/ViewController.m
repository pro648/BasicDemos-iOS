//
//  ViewController.m
//  KVC&KVO的本质
//
//  Created by pro648 on 2021/1/24.
//
//  详细介绍：https://github.com/pro648/tips/blob/master/sources/KVC%E3%80%81KVO%E7%9A%84%E6%9C%AC%E8%B4%A8.md

#import "ViewController.h"
#import "Child.h"
#import <objc/runtime.h>
#import "Person.h"
#import "Observer.h"

@interface ViewController ()

@property (nonatomic, strong) Child *child1;
@property (nonatomic, strong) Child *child2;
@property (nonatomic, strong) Observer *observer;
@property (nonatomic, strong) Person *person;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self testKVO];
    [self testKVC];
}

// MARK: - KVO

- (void)testKVO {
    self.child1 = [[Child alloc] init];
    self.child1.age = 1;

    self.child2 = [[Child alloc] init];
    self.child2.age = 2;

    // 打印添加观察者前实例对象的isa
//    NSLog(@"添加Observer前 child1: %@ - child2: %@", object_getClass(self.child1), object_getClass(self.child2));

    // 打印添加观察者前，打印setAge：具体实现。
//    NSLog(@"添加Observer前 child1: %p - child2: %p", [self.child1 methodForSelector:@selector(setAge:)], [self.child2 methodForSelector:@selector(setAge:)]);

    // 添加观察者
    [self.child1 addObserver:self
                  forKeyPath:@"age"
                     options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                     context:@"123context"];

    // 打印添加观察者后实例对象的isa
//    NSLog(@"添加Observer后 child1: %@ - child2: %@", object_getClass(self.child1), object_getClass(self.child2));

    // 打印添加观察者后，打印setAge：具体实现。
//    NSLog(@"添加Observer后 child1: %p - child2: %p", [self.child1 methodForSelector:@selector(setAge:)], [self.child2 methodForSelector:@selector(setAge:)]);

    // 打印添加观察者后，child1、child2类对象中所有方法
//    [self printMethodList:object_getClass(self.child1)];
//    [self printMethodList:object_getClass(self.child2)];
}

// 观察到键值发生改变
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    NSLog(@"监听到 %@ 的 %@ 属性值发生改变 - %@ - %@", object, keyPath, change, context);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.child1 setAge:11];

    [self.child2 setAge:22];
}

- (void)printMethodList:(Class)cls {
    unsigned int methodCount;
    // 获取方法数组
    Method *methodList = class_copyMethodList(cls, &methodCount);
    
    NSMutableString *name = [NSMutableString string];
    for (int i=0; i<methodCount; ++i) {
        // 获得方法
        Method method = methodList[i];
        // 获得方法名
        NSString *methodName = NSStringFromSelector(method_getName(method));
        
        [name appendString:methodName];
        [name appendString:@", "];
    }
    
    // C语言中使用copy、create创建的对象需释放。
    free(methodList);
    NSLog(@"%@ %@", cls, name);
}

- (void)printIvarList:(Class)cls {
    unsigned int ivarCount;
    // 获取ivar数组
    Ivar *ivarList = class_copyIvarList(cls, &ivarCount);
    // 存储ivar名
    NSMutableString *ivarNames = [NSMutableString string];
    
    // 遍历所有的ivar
    for (int i=0; i<ivarCount; ++i) {
        // 获得ivar
        Ivar ivar = ivarList[i];
        // 获得ivar名
        NSString *methodName = [NSString stringWithUTF8String:ivar_getName(ivar)];
        // 拼接ivar名
        [ivarNames appendString:methodName];
        [ivarNames appendString:@", "];
    }
    
    // C语言中使用create、copy创建的对象，需释放。
    free(ivarList);
    NSLog(@"%@ %@", cls, ivarNames);
}

// MARK: - KVC

- (void)testKVC {
    self.observer = [[Observer alloc] init];
    self.person = [[Person alloc] init];
    
    [self.person addObserver:self.observer
                  forKeyPath:@"age"
                     options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                     context:NULL];
    
//    [self printIvarList:[Person class]];
    [self.person setValue:@10 forKey:@"age"];
    
    NSLog(@"age: %@", [self.person valueForKey:@"age"]);
    
    NSLog(@"");
    
}

- (void)dealloc {
    // 移除观察者
    [self.child1 removeObserver:self
                     forKeyPath:@"age"];
    [self.person removeObserver:self.observer
                     forKeyPath:@"age"];
}

@end
