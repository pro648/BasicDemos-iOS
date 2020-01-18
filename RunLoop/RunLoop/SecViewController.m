//
//  SecViewController.m
//  RunLoop
//
//  Created by pro648 on 2020/1/11.
//  Copyright © 2020 pro648. All rights reserved.
//

#import "SecViewController.h"
#import "PermanentThread.h"

@interface SecViewController ()

@property (nonatomic, strong) PermanentThread *thread;

@end

@implementation SecViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor orangeColor];
    
    self.thread = [[PermanentThread alloc] init];
//    [self.thread start];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.thread executeTask:^{
        NSLog(@"touches %s", __func__);
    }];
}


- (IBAction)stopButtonTapped:(id)sender {
    [self.thread stop];
}

- (void)dealloc {
    NSLog(@"控制器 %s", __func__);
    
//    [self.thread stop];
}

@end
