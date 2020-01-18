//
//  ViewController.m
//  RunLoop
//
//  Created by pro648 on 2020/1/9.
//  Copyright © 2020 pro648. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

void observerRunLoopActivities(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    switch (activity) {
        case kCFRunLoopEntry:
            NSLog(@"kCFRunLoopEntry -- %@", CFRunLoopCopyCurrentMode(CFRunLoopGetCurrent()));
            break;
        case kCFRunLoopBeforeTimers:
            NSLog(@"kCFRunLoopBeforeTimers");
            break;

        case kCFRunLoopBeforeSources:
            NSLog(@"kCFRunLoopBeforeSources");
            break;
        case kCFRunLoopBeforeWaiting:
            NSLog(@"kCFRunLoopBeforeWaiting");
            break;
        case kCFRunLoopAfterWaiting:
            NSLog(@"kCFRunLoopAfterWaiting");
            break;
        case kCFRunLoopExit:
            NSLog(@"kCFRunLoopExit");
            break;
        default:
            NSLog(@"default");
            break;
    }
}

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    // 创建 observer
//    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
//        switch (activity) {
//            case kCFRunLoopEntry:
//                NSLog(@"kCFRunLoopEntry -- %@", CFRunLoopCopyCurrentMode(CFRunLoopGetCurrent()));
//                break;
//            case kCFRunLoopBeforeTimers:
//                NSLog(@"kCFRunLoopBeforeTimers");
//                break;
//
//            case kCFRunLoopBeforeSources:
//                NSLog(@"kCFRunLoopBeforeSources");
//                break;
//            case kCFRunLoopBeforeWaiting:
//                NSLog(@"kCFRunLoopBeforeWaiting");
//                break;
//            case kCFRunLoopAfterWaiting:
//                NSLog(@"kCFRunLoopAfterWaiting");
//                break;
//            case kCFRunLoopExit:
//                NSLog(@"kCFRunLoopExit");
//                break;
//            default:
//                NSLog(@"default");
//                break;
//        }
//    });
//    // 将 observer 添加到主线程的 run loop 的 common modes
//    CFRunLoopAddObserver(CFRunLoopGetMain(), observer, kCFRunLoopCommonModes);
//    // 释放 observer
//    CFRelease(observer);
    
    // 也可以使用下面方式添加 observer
    /*
    // 创建 observer
    CFRunLoopObserverRef observer = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, observerRunLoopActivities, NULL);
    // 将 observer 添加到主线程的 run loop 的 common modes
    CFRunLoopAddObserver(CFRunLoopGetMain(), observer, kCFRunLoopCommonModes);
    // 释放 observer
    CFRelease(observer);
     */
    
//    [self addTimer];
}

- (void)addTimer {
    // 1.创建、配置 timer，并自动添加到当前线程 run loop
    [NSTimer scheduledTimerWithTimeInterval:0.2
                                    repeats:YES
                                      block:^(NSTimer * _Nonnull timer) {
        NSLog(@"timer 添加到了 NSDefaultRunLoopMode");
    }];
    
    // 2.创建、配置 timer，手动添加到当前线程 run loop 的 common modes
    NSRunLoop *myRunLoop = [NSRunLoop currentRunLoop];
    NSTimer *timer = [NSTimer timerWithTimeInterval:1.0
                                            repeats:YES
                                              block:^(NSTimer * _Nonnull timer) {
        NSLog(@"timer 添加到了 NSRunLoopCommonModes");
    }];
    [myRunLoop addTimer:timer forMode:NSRunLoopCommonModes];
    
    // 3.使用 Core Foundation 创建并安排 timer
    CFRunLoopRef runloop = CFRunLoopGetCurrent();
    CFRunLoopTimerContext context = {0, NULL, NULL, NULL, NULL};
    CFRunLoopTimerRef cfTimer = CFRunLoopTimerCreate(kCFAllocatorDefault, 0.1, 0.3, 0, 0, &myCFTimerCallback, &context);
    CFRunLoopAddTimer(runloop, cfTimer, kCFRunLoopCommonModes);
}

void myCFTimerCallback() {
    NSLog(@"timer 添加到了 CFRunLoopTimerRef");
}

@end
