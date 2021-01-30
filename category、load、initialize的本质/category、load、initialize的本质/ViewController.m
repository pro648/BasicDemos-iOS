//
//  ViewController.m
//  category、load、initialize的本质
//
//  Created by pro648 on 2021/1/26.
//
//  详细介绍：https://github.com/pro648/tips/blob/master/sources/%E5%88%86%E7%B1%BBcategory%E3%80%81load%E3%80%81initialize%E7%9A%84%E6%9C%AC%E8%B4%A8%E5%92%8C%E6%BA%90%E7%A0%81%E5%88%86%E6%9E%90.md

#import "ViewController.h"
#import "Child+Test1.h"
#import "Child+Test2.h"
#import "Student+Test1.h"
#import "Student+Test2.h"
#import "Dog.h"
#import "Cat.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self testCategory];
//    [self testInitializer];
}

- (void)testCategory {
    Child *child = [[Child alloc] init];
    [child test];
}

- (void)testInitializer {
    [Dog alloc];
    [Cat alloc];
    [Person alloc];
    [Student alloc];
}

@end
