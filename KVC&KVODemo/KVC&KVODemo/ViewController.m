//
//  ViewController.m
//  KVC&KVODemo
//
//  Created by ad on 01/03/2017.
//
//  详细介绍：https://github.com/pro648/tips/wiki/KVC%E5%92%8CKVO%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B0

#import "ViewController.h"
#import "Children.h"

@interface ViewController ()

@property (nonatomic, strong) Children *child1;
@property (nonatomic, strong) Children *child2;

@end

static void *child1Context = &child1Context;
static void *child2Context = &child2Context;

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // child1
    self.child1 = [Children new];
    
    // 1.使用KVC设值
    [self.child1 setValue:@"Jr" forKey:@"firstName"];
    [self.child1 setValue:[NSNumber numberWithUnsignedInteger:39] forKey:@"age"];
    
    // 2. 取值 输出到控制台
    NSString *childFirstName = [self.child1 valueForKey:@"firstName"];
    NSUInteger child1Age = [[self.child1 valueForKey:@"age"] unsignedIntegerValue];
    NSLog(@"%@,%lu",childFirstName,child1Age);
    
    // child2
    self.child2 = [Children new];
    [self.child2 setValue:@"Ivanka" forKey:@"firstName"];
    [self.child2 setValue:[NSNumber numberWithUnsignedInteger:35] forKey:@"age"];
    self.child2.child = [Children new];
    
    [self.child2 setValue:@"Eric" forKeyPath:@"child.firstName"];
    [self.child2 setValue:[NSNumber numberWithUnsignedInteger:33] forKeyPath:@"child.age"];
    
    NSLog(@"%@,%lu",self.child2.child.firstName, self.child2.child.age);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.child1 addObserver:self forKeyPath:@"firstName" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:child1Context];
    [self.child1 addObserver:self forKeyPath:@"age" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:child1Context];
    
    // 添加观察者后改变值 验证是否可以观察到值变化
    [self.child1 willChangeValueForKey:@"firstName"];
    [self.child1 setValue:@"Tiffany" forKey:@"firstName"];
    [self.child1 didChangeValueForKey:@"firstName"];
    
    [self.child1 setValue:[NSNumber numberWithUnsignedInteger:23] forKey:@"age"];
    
    // 观察child2属性变化 设值
    [self.child2 addObserver:self forKeyPath:@"age" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:child2Context];
    [self.child2 setValue:[NSNumber numberWithUnsignedInteger:64] forKey:@"age"];
    
    // 添加观察者 观察fullName属性 修改firstName lastName
    [self.child1 addObserver:self forKeyPath:@"fullName" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:child1Context];
    self.child1.lastName = @"Trump";
    self.child1.firstName = @"Ivana";
    
    // 对数组进行观察
    [self.child1 addObserver:self forKeyPath:@"cousins.array" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
    [self.child1.cousins insertObject:@"Antony" inArrayAtIndex:0];
    [self.child1.cousins insertObject:@"Julia" inArrayAtIndex:1];
    [self.child1.cousins replaceObjectInArrayAtIndex:0 withObject:@"Ben"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // 移除所有观察者
    [self.child1 removeObserver:self forKeyPath:@"firstName" context:child1Context];
    [self.child1 removeObserver:self forKeyPath:@"age" context:child1Context];
    [self.child1 removeObserver:self forKeyPath:@"fullName" context:child1Context];
    [self.child1 removeObserver:self forKeyPath:@"cousins.array" context:NULL];
    [self.child2 removeObserver:self forKeyPath:@"age" context:child2Context];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    // 没有使用context
//    if ([keyPath isEqualToString:@"firstName"] )
//    {
//        NSLog(@"The name of the child was changed.\n %@",change);
//    }
//    else if ([keyPath isEqualToString:@"age"])
//    {
//        NSLog(@"The new value is %@,The old value is %@",[change valueForKey:NSKeyValueChangeNewKey],[change valueForKey:NSKeyValueChangeOldKey]);
//    }
    
    // 使用context后
    if (context == child1Context)
    {
        if ([keyPath isEqualToString:@"firstName"])
        {
            NSLog(@"The name of the FIRST child was changed.\n %@",change);
        }
        else if ([keyPath isEqualToString:@"age"])
        {
            NSLog(@"The new value of the FIRST child is %@,The new value of the FIRST child is %@",[change valueForKey:NSKeyValueChangeNewKey],[change valueForKey:NSKeyValueChangeOldKey]);
        }
        else if ([keyPath isEqualToString:@"fullName"])
        {
            NSLog(@"The full name of First child was change.\n %@",change);
        }
    }
    else if (context == child2Context)
    {
        if ([keyPath isEqualToString:@"age"])
        {
            NSLog(@"The new value of the SECOND child is %@,The new value of the SECOND child is %@",[change valueForKey:NSKeyValueChangeNewKey],[change valueForKey:NSKeyValueChangeOldKey]);
        }
    }
    else if ([keyPath isEqualToString:@"cousins.array"] && [object isKindOfClass:[Children class]])
    {
        NSLog(@"cousins.array %@",change);
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
