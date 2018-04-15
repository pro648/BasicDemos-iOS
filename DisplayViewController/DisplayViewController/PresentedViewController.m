//
//  PresentedViewController.m
//  DisplayViewController
//
//  Created by pro648 on 14/04/2018.
//  Copyright © 2018 pro648. All rights reserved.
//

#import "PresentedViewController.h"

@interface PresentedViewController ()

@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation PresentedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.label.text = self.text;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
