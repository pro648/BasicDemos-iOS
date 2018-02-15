//
//  GrandCentralDispatchTests.m
//  GrandCentralDispatchTests
//
//  Created by ad on 07/02/2018.
//

#import <XCTest/XCTest.h>
#import "PhotoManager.h"

@interface GrandCentralDispatchTests : XCTestCase

@end

extern NSString * const baseURLString;

@implementation GrandCentralDispatchTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

// Xcode会在主线程测试所有以test开头的方法。
- (void)testPennyImageURL {
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseURLString, @"Penny.jpg"];
    [self downloadImageURLWithString:urlString];
}

- (void)testFriendsImageURL {
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseURLString,@"Friends.jpg"];
    [self downloadImageURLWithString:urlString];
}

- (void)testNightKingImageURL {
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseURLString,@"NightKing.jpg"];
    [self downloadImageURLWithString:urlString];
}

- (void)downloadImageURLWithString:(NSString *)urlString {
    // 创建信号，参数指信号量初始值。
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    NSURL *url = [NSURL URLWithString:urlString];
    __unused Photo *photo = [[Photo alloc] initWithURL:url withCompletionBlock:^(UIImage *image, NSError *error) {
        if (error) {
            XCTFail(@"%@ failed. %@",urlString, error);
        }

        // 增加信号量。
        dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_time_t timeOutTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC));
    // 等待信号10秒钟（即timeOutTime）。这会堵塞线程，直到信号量大于0。当超时没有完成时，返回非零值，即测试失败。在指定时间完成时，返回零。
    if (dispatch_semaphore_wait(semaphore, timeOutTime)) {
        XCTFail(@"%@ timed out",urlString);
    }
}

@end
