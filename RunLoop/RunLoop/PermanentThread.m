//
//  PermanentThread.m
//  RunLoop
//
//  Created by pro648 on 2020/1/11.
//  Copyright © 2020 pro648. All rights reserved.
//
//  详细介绍：https://github.com/pro648/tips/wiki/RunLoop%E4%BB%8E%E5%85%A5%E9%97%A8%E5%88%B0%E8%BF%9B%E9%98%B6

#import "PermanentThread.h"

@interface CustomThread : NSThread

@end

@implementation CustomThread

- (void)dealloc {
    NSLog(@"销毁自定义线程 %s", __PRETTY_FUNCTION__);
}

@end

@interface PermanentThread ()

@property (nonatomic, strong) CustomThread *innerThread;
@property (nonatomic, assign, getter=isStopped) BOOL stopped;

@end

@implementation PermanentThread

- (instancetype)init {
    self = [super init];
    if (self) {
        __weak typeof(self) weakSelf = self;
        self.innerThread = [[CustomThread alloc] initWithBlock:^{
//            [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
//
//            while (weakSelf && !weakSelf.isStopped) {
//                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
//            };
            
            
//            // 创建 observer
//            CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
//                switch (activity) {
//                    case kCFRunLoopEntry:
//                        NSLog(@"kCFRunLoopEntry -- %@", CFRunLoopCopyCurrentMode(CFRunLoopGetCurrent()));
//                        break;
//                    case kCFRunLoopBeforeTimers:
//                        NSLog(@"kCFRunLoopBeforeTimers");
//                        break;
//
//                    case kCFRunLoopBeforeSources:
//                        NSLog(@"kCFRunLoopBeforeSources");
//                        break;
//                    case kCFRunLoopBeforeWaiting:
//                        NSLog(@"kCFRunLoopBeforeWaiting");
//                        break;
//                    case kCFRunLoopAfterWaiting:
//                        NSLog(@"kCFRunLoopAfterWaiting");
//                        break;
//                    case kCFRunLoopExit:
//                        NSLog(@"kCFRunLoopExit");
//                        break;
//                    default:
//                        NSLog(@"default");
//                        break;
//                }
//            });
//            // 将 observer 添加到当前线程的 run loop 的 common modes
//            CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, kCFRunLoopCommonModes);
//            // 释放 observer
//            CFRelease(observer);
            
            // C 语言版本
            // 上下文
            CFRunLoopSourceContext context = {0};
            
            // 创建 source
            CFRunLoopSourceRef source = CFRunLoopSourceCreate(kCFAllocatorDefault, 0, &context);
            
            // 添加 source 到 run loop
            CFRunLoopAddSource(CFRunLoopGetCurrent(), source, kCFRunLoopDefaultMode);
            
            // 销毁 source
            CFRelease(source);
            
            // 启动
            while (weakSelf && !weakSelf.stopped) {
                //第三个参数 returnAfterSourceHandled 设置为 true，代表执行完source后就退出当前loop
                // 设置为 false后，就不再需要 stopped 属性。
                SInt32 result = CFRunLoopRunInMode(kCFRunLoopDefaultMode, 1.0e10, true);
                
                if (result == kCFRunLoopRunStopped) {
                    NSLog(@"run stopped");
                } else if (result == kCFRunLoopRunFinished) {
                    weakSelf.stopped = YES;
                    NSLog(@"run finished");
                } else if (result == kCFRunLoopRunTimedOut) {
                    NSLog(@"run timeout");
                } else if (result == kCFRunLoopRunHandledSource) {
                    NSLog(@"run handle");
                }
            }
            
            NSLog(@"--- end");
        }];
    }
    return self;
}

- (void)executeTask:(PermanentThreadTask)task {
    if (!task || !self.innerThread) {
        return;
    }
    
    if (![self.innerThread isExecuting]) {
        [self.innerThread start];
    }
    
    [self performSelector:@selector(_executeTask:) onThread:self.innerThread withObject:task waitUntilDone:NO];
}

//- (void)start {
//    if (!self.innerThread) {
//        return;
//    }
//
//    [self.innerThread start];
//}

- (void)stop {
    if (!self.innerThread) {
        return;
    }
    
    [self performSelector:@selector(_stop) onThread:self.innerThread withObject:NULL waitUntilDone:YES];
}

- (void)dealloc {
    NSLog(@"线程 %s", __func__);
    
    [self stop];
}

// MARK: - Private Methodes

- (void)_stop {
    self.stopped = YES;
    CFRunLoopStop(CFRunLoopGetCurrent());
    
    self.innerThread = nil;
}

- (void)_executeTask:(PermanentThreadTask)task {
    task();
}

@end
