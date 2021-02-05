//
//  Child+Test.m
//  AssociatedObject
//
//  Created by pro648 on 2021/2/2.
//  

#import "Child+Test.h"
#import <objc/runtime.h>

@implementation Child (Test)

// 关联对象

// 占4个字节
int age = 0;

// 指针变量，占8个字节。
static const void *vNameKey = &vNameKey;

// 只占一个字节
static const char cNameKey;

- (void)setName:(NSString *)name {
    objc_setAssociatedObject(self, @selector(name), name, OBJC_ASSOCIATION_COPY_NONATOMIC);
//    objc_setAssociatedObject(self, &age, name, OBJC_ASSOCIATION_COPY_NONATOMIC);
//    objc_setAssociatedObject(self, @"pro648", name, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)name {
    return objc_getAssociatedObject(self, @selector(name));
//    return objc_getAssociatedObject(self, &age);
//    return objc_getAssociatedObject(self, @"pro648");
}

/*
// 使用字典存储成员变量的值
// 缺点：添加一个属性，就需要添加一个字典，很麻烦。存在内存泄漏、线程安全问题。

NSMutableDictionary *nameDict;
#define key [NSString stringWithFormat:@"%p", self]

+ (void)initialize {
    if (self == Child.class) {
        nameDict = [NSMutableDictionary dictionary];
    }
}

- (void)setName:(NSString *)name {
    nameDict[key] = name;
}

- (NSString *)name {
    return nameDict[key];
}
 */

/*
// 使用全局变量存储成员变量的值
// 问题：不能区分不同实例
static NSString *_name;
- (void)setName:(NSString *)name {
    _name = name;
}

- (NSString *)name {
    return _name;
}
 */

@end
