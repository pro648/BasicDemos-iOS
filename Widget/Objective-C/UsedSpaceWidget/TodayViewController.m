//
//  TodayViewController.m
//  UsedSpaceWidget
//
//  Created by pro648 on 18/7/22
//  Copyright © 2018年 pro648. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding>

@property (weak, nonatomic) IBOutlet UILabel *percentLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailsLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (nonatomic, assign) double totalDiskSpaceInBytes;
@property (nonatomic, assign) double freeDiskSpaceInBytes;
@property (nonatomic, assign) double usedDiskSpaceInBytes;

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 点击手势
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    self.detailsLabel.numberOfLines = 3;

    self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded;
    
    [self updateUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize {
    if (activeDisplayMode == NCWidgetDisplayModeCompact) {
        self.preferredContentSize = maxSize;
        self.detailsLabel.hidden = YES;
    } else {
        self.preferredContentSize = CGSizeMake(0, 180);
        self.detailsLabel.hidden = NO;
    }
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    double rate = [[NSUserDefaults standardUserDefaults] doubleForKey:@"rate"];
    double newRate = self.usedDiskSpaceInBytes / self.totalDiskSpaceInBytes;
    
    if (fabs(rate - newRate) < 0.0001) {
        // 如果容量变化小于0.0001，将不更新界面。
        completionHandler(NCUpdateResultNoData);
    } else {
        // 只有容量变化大于0.0001时，才更新界面。
        [self updateUI];
        completionHandler(NCUpdateResultNewData);
    }
}

#pragma mark - Help Methods

- (void)updateUI {
    double rate = self.usedDiskSpaceInBytes / self.totalDiskSpaceInBytes;
    
    // 缓存使用比例
    [NSUserDefaults.standardUserDefaults setDouble:rate forKey:@"rate"];
    
    self.percentLabel.text = [NSString stringWithFormat:@"%.1f%%",rate * 100];
    self.progressView.progress = rate;
    
    self.detailsLabel.text = [NSString stringWithFormat:@"Used:\t%@\nFree:\t%@\nTotal:\t%@",
                              [self convertByteToGB:self.usedDiskSpaceInBytes],
                              [self convertByteToGB:self.freeDiskSpaceInBytes],
                              [self convertByteToGB:self.totalDiskSpaceInBytes]];
}

// byte转换为GB
- (NSString *)convertByteToGB:(double)bytes {
    NSByteCountFormatter *formatter = [[NSByteCountFormatter alloc] init];
    [formatter setCountStyle:NSByteCountFormatterCountStyleFile];
    
    return [formatter stringFromByteCount:bytes];
}

#pragma mark - IBAction

- (void)handleSingleTap:(UITapGestureRecognizer *)sender {
    NSURL *firstURL = [NSURL URLWithString:@"widget://first/word?From%20Widget%20To%20First%20VC"];
    NSURL *secondURL = [NSURL URLWithString:@"widget://second/word?From%20Widget%20To%20Second%20VC"];
    
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.pro648.widget.swift"];
    BOOL isFirst = [userDefaults boolForKey:@"first"];
    
    NSURL *url;
    if (isFirst) {
        url = secondURL;
    } else {
        url = firstURL;
    }
    
    [self.extensionContext openURL:url completionHandler:^(BOOL success) {
        NSLog(@"Successfully open %@",url.query.stringByRemovingPercentEncoding);
    }];
}

#pragma mark - Getters & Setters

// 设备总空间
- (double)totalDiskSpaceInBytes {
    NSDictionary *dict = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:NULL];
    return [dict[NSFileSystemSize] doubleValue];
}

// 还未使用空间
- (double)freeDiskSpaceInBytes {
    NSURLResourceKey volumeCapacityKey;
    if (@available(iOS 11.0, *)) {
        volumeCapacityKey = NSURLVolumeAvailableCapacityForImportantUsageKey;
    } else {
        volumeCapacityKey = NSURLVolumeAvailableCapacityKey;
    }
    
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:@"/"];
    NSError *error = nil;
    NSDictionary *results = [fileURL resourceValuesForKeys:@[volumeCapacityKey] error:&error];
    if (error) {
        NSLog(@"Error retrieving resource keys: %@\n%@",[error localizedDescription],[error userInfo]);
        abort();
    } else {
        return [results[volumeCapacityKey] doubleValue];
    }
}

// 已使用空间
- (double)usedDiskSpaceInBytes {
    return self.totalDiskSpaceInBytes - self.freeDiskSpaceInBytes;
}

@end
