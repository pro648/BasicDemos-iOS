//
//  DataViewController.m
//  PageViewController
//
//  Created by pro648 on 2018/6/2.
//  Copyright © 2018 pro648. All rights reserved.
//

#import "DataViewController.h"

@interface DataViewController ()

@property (nonatomic, strong) UILabel *dayLabel;
@property (nonatomic, strong) UILabel *quoteLabel;

@end

@implementation DataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.dayLabel];
    [self.view addSubview:self.quoteLabel];
    
    self.view.backgroundColor = [UIColor brownColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.dayLabel.text = [NSString stringWithFormat:@"Page %lu %@",self.itemIndex + 1, [self.day description]];
    self.quoteLabel.text = self.quote;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Getters & Setters

- (UILabel *)dayLabel {
    if (!_dayLabel) {
        _dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, CGRectGetWidth(self.view.bounds), 20)];
        _dayLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        _dayLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _dayLabel;
}

- (UILabel *)quoteLabel {
    if (!_quoteLabel) {
        _quoteLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 50)];
        _quoteLabel.frame = CGRectInset(_quoteLabel.frame, 16, 0);
        _quoteLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle1];
        _quoteLabel.textAlignment = NSTextAlignmentCenter;
        _quoteLabel.numberOfLines = 0;
    }
    return _quoteLabel;
}

@end
