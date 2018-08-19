//
//  ViewController.m
//  copy&mutableCopy
//
//  Created by ad on 02/08/2017.
//
//  详细介绍：https://github.com/pro648/tips/wiki/%E6%B7%B1%E5%A4%8D%E5%88%B6%E3%80%81%E6%B5%85%E5%A4%8D%E5%88%B6%E3%80%81copy%E3%80%81mutableCopy

#import "ViewController.h"
#import "Person.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1.非容器类 不可变对象
    [self immutableObject];
    
    // 2.非容器类 可变对象
    [self mutableObject];
    
    // 3.浅复制容器类对象
    [self shallowCopyCollections];
    
    // 4.容器类一层深复制
    [self oneLevelDeepCopy];
    
    // 5.使用归档进行完全深复制。
    [self trueDeepCopy];
    
    // 6.自定义类的复制
    [self copyCustomClass];
    
    // 7.更改指针指向地址
    [self pointToAnotherMemoryAddress];
}

// 1.非容器类 不可变对象
- (void)immutableObject {
    // 1.创建一个string字符串。
    NSString *string = @"github.com/pro648";
    NSString *stringB = string;
    NSString *stringCopy = [string copy];
    NSMutableString *stringMutableCopy = [string mutableCopy];
    
    // 2.输出指针指向的内存地址。
    NSLog(@"Memory location of string = %p",string);
    NSLog(@"Memory location of stringB = %p",stringB);
    NSLog(@"Memory location of stringCopy = %p",stringCopy);
    NSLog(@"Memory location of stringMutableCopy = %p",stringMutableCopy);
}

// 2.非容器类 可变对象
- (void)mutableObject {
    // 1.创建一个可变字符串。
    NSMutableString *mString = [NSMutableString stringWithString:@"github.com/pro648"];
    NSString *mStringCopy = [mString copy];
    NSMutableString *mutablemString = [mString copy];
    NSMutableString *mStringMutableCopy = [mString mutableCopy];
    
    // 2.在可变字符串后添加字符串。
    [mString appendString:@"AA"];
//    [mutablemString appendString:@"BB"];  // 运行时，这一行会报错。
    [mStringMutableCopy appendString:@"CC"];
    
    // 3.输出指针指向的内存地址。
    NSLog(@"Memory location of \n mString = %p,\n mstringCopy = %p,\n mutablemString = %p,\n mStringMutableCopy = %p",mString, mStringCopy, mutablemString, mStringMutableCopy);
}

// 3.浅复制容器类对象。
- (void)shallowCopyCollections {
    // 1.创建一个不可变数组，数组内元素为可变字符串。
    NSMutableString *red = [NSMutableString stringWithString:@"Red"];
    NSMutableString *green = [NSMutableString stringWithString:@"Green"];
    NSMutableString *blue = [NSMutableString stringWithString:@"Blue"];
    NSArray *myArray1 = [NSArray arrayWithObjects:red, green, blue, nil];
    
    // 2.进行浅复制。
    NSArray *myArray2 = [myArray1 copy];
    NSMutableArray *myMutableArray3 = [myArray1 mutableCopy];
    NSArray *myArray4 = [[NSArray alloc] initWithArray:myArray1];
    
    // 3.修改myArray2的第一个元素。
    NSMutableString *tempString = myArray2.firstObject;
    [tempString appendString:@"Color"];
    
    // 4.输出四个数组内存地址，输出四个数组。
    NSLog(@"Memory location of \n myArray1 = %p, \n myArray2 %p, \n myMutableArray3 %p, \n myArray4 %p",myArray1, myArray2, myMutableArray3, myArray4);
    NSLog(@"Contents of \n myArray1 %@, \n myArray2 %@, \n myMutableArray3 %@, \n myArray4 %@",myArray1, myArray2, myMutableArray3, myArray4);
}

// 4.容器类一层深复制
- (void)oneLevelDeepCopy {
    // 1.创建一个不可变数组，数组内元素为可变字符串。
    NSMutableString *red = [NSMutableString stringWithString:@"Red"];
    NSMutableString *green = [NSMutableString stringWithString:@"Green"];
    NSMutableString *blue = [NSMutableString stringWithString:@"Blue"];
    NSArray *myArray1 = [NSArray arrayWithObjects:red, green, blue, nil];
    
    // 2.进行浅复制。
    NSArray *myArray2 = [myArray1 copy];
    NSMutableArray *myMutableArray3 = [myArray1 mutableCopy];
    NSArray *myArray4 = [[NSArray alloc] initWithArray:myArray1 copyItems:YES];
    
    // 3.修改myArray2的第一个元素。
    NSMutableString *tempString = myArray2.firstObject;
    [tempString appendString:@"Color"];
    
    // 4.输出四个数组内存地址，输出四个数组。
    NSLog(@"Memory location of \n myArray1.firstObject = %p, \n myArray2.firstObject %p, \n myMutableArray3.firstObject %p, \n myArray4.firstObject %p",myArray1.firstObject, myArray2.firstObject, myMutableArray3.firstObject, myArray4.firstObject);
    NSLog(@"Contents of \n myArray1 %@, \n myArray2 %@, \n myMutableArray3 %@, \n myArray4 %@",myArray1, myArray2, myMutableArray3, myArray4);
}

// 5.使用归档进行完全深复制。
- (void)trueDeepCopy {
    // 1.创建一个可变数组，数组第一个元素是另一个可变数组，第二个元素是另一个不可变数组。
    NSMutableString *hue = [NSMutableString stringWithString:@"hue"];
    NSMutableString *saturation = [NSMutableString stringWithString:@"saturation"];
    NSMutableString *brightness = [NSMutableString stringWithString:@"brightness"];
    NSMutableArray *hsbArray1 = [NSMutableArray arrayWithObjects:hue, saturation, brightness, nil];
    NSArray *hsbArray2 = [NSArray arrayWithObjects:hue, saturation, brightness, nil];
    NSMutableArray *hsbArray3 = [NSMutableArray arrayWithObjects:hsbArray1, hsbArray2, nil];
    
    // 2.通过归档、解档进行完全深复制。
    NSData *dataArea = [NSKeyedArchiver archivedDataWithRootObject:hsbArray3];
    NSMutableArray *hsbArray4 = [NSKeyedUnarchiver unarchiveObjectWithData:dataArea];
    
    // 3.输出hsbArray3和hsbArray4数组第一个元素内存地址。
    NSLog(@"Memory location of \n hsbArray3.firstObject = %p, \n hsbArray4.firstObject = %p",hsbArray3.firstObject, hsbArray4.firstObject);
    
    // 4.为hsbArray4第一个元素添加字符串。
    NSMutableArray *tempArray1 = hsbArray4.firstObject;
    [tempArray1 addObject:@"hsb"];
    
    // 5.hsbArray4第二个元素是hsbArray2，而hsbArray2是不可变数组，这一步将产生错误。
//    NSMutableArray *tempArray2 = hsbArray4[1];
//    [tempArray2 addObject:@"Color"];
    
    // 6.输出数组内容。
    NSLog(@"Contents of \n hsbArray3 %@, \n hsbArray4 %@",hsbArray3, hsbArray4);
}

// 6.自定义类的复制
- (void)copyCustomClass {
    Person *person = [[Person alloc] init];
    [person setName:@"A" withAge:1];
    
    Person *personCopy = [person copy];
    [personCopy setName:@"B" withAge:2];
    // 断点位置
}

// 7.更改指针指向地址
- (void)pointToAnotherMemoryAddress {
    // 1.指针a、b同时指向字符串pro
    NSString *a = @"pro";
    NSString *b = a;
    NSLog(@"Memory location of \n a = %p, \n b = %p", a, b);
    // 断点1位置
    
    // 2.指针a指向字符串pro648
    a = @"pro648";
    NSLog(@"Memory location of \n a = %p, \n b = %p", a, b);
    // 断点2位置
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
