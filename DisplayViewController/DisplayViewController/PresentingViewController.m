//
//  PresentingViewController.m
//  DisplayViewController
//
//  Created by pro648 on 14/04/2018.
//  Copyright © 2018 pro648. All rights reserved.
//

#import "PresentingViewController.h"
#import "PresentedViewController.h"

@interface PresentingViewController ()

@end

@implementation PresentingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"coverVertical"]) {
        PresentedViewController *presentedVC = segue.destinationViewController;
        presentedVC.text = @"UIModalTransitionStyleCoverVertical";
    } else if ([segue.identifier isEqualToString:@"flipHorizontal"]) {
        PresentedViewController *presentedVC = segue.destinationViewController;
        presentedVC.text = @"UIModalTransitionStyleFlipHorizontal";
    } else if ([segue.identifier isEqualToString:@"crossDissolve"]) {
        PresentedViewController *presentedVC = segue.destinationViewController;
        presentedVC.text = @"UIModalTransitionStyleCrossDissolve";
    } else if ([segue.identifier isEqualToString:@"partialCurl"]) {
        PresentedViewController *presentedVC = segue.destinationViewController;
        presentedVC.text = @"UIModalTransitionStylePartialCurl";
    }
}

- (IBAction)unwindAction:(UIStoryboardSegue *)unwindSegue {
    
}

@end
