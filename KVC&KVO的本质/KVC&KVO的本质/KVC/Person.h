//
//  Person.h
//  KVC&KVO的本质
//
//  Created by pro648 on 2021/1/24.
//  

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject
{
    @public
    // 如果没有set方法，按照下面顺序查找。
//    int _age;
    int _isAge;
    int age;
    int isAge;
}

// 如果没有setAge方法，但有上述成员变量，就会触发KVO。KVO内部实现了willChangeValueForKey didChangeValueForKey。

//@property (nonatomic, assign) int age;

// 如果是只读的，则会查看accessInstanceMethodDirectly返回值，进而决定是否查看成员变量。
//@property (nonatomic, assign, readonly) int age;

@end

NS_ASSUME_NONNULL_END
