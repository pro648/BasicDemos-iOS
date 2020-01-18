//
//  PermanentThread.h
//  RunLoop
//
//  Created by pro648 on 2020/1/11.
//  Copyright © 2020 pro648. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^PermanentThreadTask)(void);

@interface PermanentThread : NSObject

- (void)stop;
- (void)executeTask:(PermanentThreadTask)task;

@end

NS_ASSUME_NONNULL_END
