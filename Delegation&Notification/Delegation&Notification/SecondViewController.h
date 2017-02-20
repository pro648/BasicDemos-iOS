//
//  SecondViewController.h
//  Delegation&Notification
//
//  Created by ad on 19/02/2017.
//
//

#import <UIKit/UIKit.h>

@protocol SendTextDelegate <NSObject>

- (void)sendText:(NSString *)string;

@end

@interface SecondViewController : UIViewController

@property (weak, nonatomic) id<SendTextDelegate> delegate;

@end
