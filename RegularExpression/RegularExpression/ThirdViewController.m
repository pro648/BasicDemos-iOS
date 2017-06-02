//
//  ThirdViewController.m
//  RegularExpression
//
//  Created by ad on 28/05/2017.
//
//  demo详细介绍：https://github.com/pro648/tips/wiki/%E6%AD%A3%E5%88%99%E8%A1%A8%E8%BE%BE%E5%BC%8FNSRegularExpression

#import "ThirdViewController.h"

// TODO: To be implemented from tutorial.
#define kSocialSecurityNumberPattern @"^\\d{3}[-]\\d{2}[-]\\d{4}$"

@interface ThirdViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *ssnTextField;

@end

@implementation ThirdViewController

#pragma mark
#pragma mark View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // ssnTextField text change
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    
    // For convenience, if user double tapps anywhere on the view we want to dismiss the keyboard.
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapGestureRecognized:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.tableView addGestureRecognizer:doubleTap];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self validateTextField:self.ssnTextField];
    [self.ssnTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

#pragma mark
#pragma mark IBAction

- (void)doubleTapGestureRecognized:(id)sender{
    [self.ssnTextField resignFirstResponder];
}

- (void)textDidChanged:(NSNotification *)notification{
    UITextField *textField = (UITextField *)notification.object;
    [self validateTextField:textField];
}

#pragma mark
#pragma mark UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *text = textField.text;
    NSUInteger length = text.length;
    BOOL shouldReplace = YES;
    if (![string isEqualToString:@""]) {
        switch (length) {
            case 3:
            case 6:
                textField.text = [text stringByAppendingString:@"-"];
                break;
                
            default:
                break;
        }
        if (length > 10) {
            shouldReplace = NO;
        }
    }
    else
    {
        switch (length) {
            case 5:
            case 8:
                textField.text = [text substringWithRange:NSMakeRange(0, length-1)];
                break;
                
            default:
                break;
        }
    }
    
    return shouldReplace;
}

#pragma mark
#pragma mark Validation

- (void)validateTextField:(UITextField *)textField{
    NSString *text = textField.text;
    
    UIImageView *rightImageView = (UIImageView *)textField.rightView;
    
    if (! text.length) {
        rightImageView = nil;
        textField.rightViewMode = UITextFieldViewModeNever;
    }
    else
    {
        if (! rightImageView) {
            rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30.0, 30.0)];
            textField.rightView = rightImageView;
        }
        
        // Perform the validation
        BOOL didValidate = [self validateString:text withPattern:kSocialSecurityNumberPattern];
        if (didValidate) {
            rightImageView.image = [UIImage imageNamed:@"checkmark.png"];
            textField.rightViewMode = UITextFieldViewModeAlways;
        }
        else
        {
            rightImageView.image = [UIImage imageNamed:@"exclamation.png"];
            textField.rightViewMode = UITextFieldViewModeAlways;
        }
    }
}

// Validate the input string with the given pattern and return the result as a boolean
- (BOOL)validateString:(NSString *)text withPattern:(NSString *)pattern{
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    NSAssert(regex, @"Unable to create regular expression");
    NSRange matchRange = [regex rangeOfFirstMatchInString:text options:NSMatchingReportProgress range:NSMakeRange(0, text.length)];
    BOOL didValidate = NO;
    if (matchRange.location != NSNotFound) {
        didValidate = YES;
    }
    
    return didValidate;
}

@end
