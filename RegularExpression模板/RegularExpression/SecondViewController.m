//
//  SecondViewController.m
//  RegularExpression
//
//  Created by ad on 28/05/2017.
//
//  demo详细介绍：https://github.com/pro648/tips/wiki/%E6%AD%A3%E5%88%99%E8%A1%A8%E8%BE%BE%E5%BC%8FNSRegularExpression

#import "SecondViewController.h"

@interface SecondViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *middleInitialTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *dateOfBirthTextField;
@property (strong, nonatomic) NSArray *textFields;
@property (strong, nonatomic) NSArray *validations;

@end

@implementation SecondViewController

#pragma mark
#pragma mark View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Keep an array of text field to make it first responder upon tapping on the next button.
    self.textFields = @[self.firstNameTextField,
                        self.middleInitialTextField,
                        self.lastNameTextField,
                        self.dateOfBirthTextField
                        ];
    for (UITextField *textField in self.textFields) {
        textField.returnKeyType = UIReturnKeyNext;
    }
    
    // Array of regex to validate each field.
    // TODO: To be implemented from tutorial.
    self.validations = nil;
    
    // For convenience, if user double taps anywhere on the view we want to dismiss the keyboard
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapGestureRecognized:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.tableView addGestureRecognizer:doubleTap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark IBAction

- (void)doubleTapGestureRecognized:(id)sender{
    [self.textFields makeObjectsPerformSelector:@selector(resignFirstResponder)];
}

#pragma mark
#pragma mark UITextFieldDelegate

// Called when user taps next button
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    // Validate
    [self validateTextField:textField];
    
    // Find the next text field to make it the first responder and scroll the table view to make that text field visible
    UITextField *nextTextField = [self nextTextFieldAfterTextField:textField];
    
    // To make it visible, find the UITalbleViewCell that hosts the text field and scroll to that
    UITableViewCell *cell = (UITableViewCell *)nextTextField.superview.superview;
    CGRect cellRect = cell.frame;
    [self.tableView scrollRectToVisible:cellRect animated:YES];
    
    // Make it first responder
    [textField becomeFirstResponder];
    
    return YES;
}

// Called when user taps on clear button
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    // We are going to return yes and clear out but the text field is not cleared yet, Because for correct validation icon on the right side of the text field, we need the text field to have a clear text, so we set it manually to nil.
    textField.text = nil;
    
    // Validate
    [self validateTextField:textField];
    
    return YES;
}

// Called when user taps on a different text field and this text field resigns.
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self validateTextField:textField];
}

#pragma mark
#pragma mark Help Methods

// Return a pointer to the next text field that should become the next responder
- (UITextField *)nextTextFieldAfterTextField:(UITextField *)textField{
    // Index of current textField
    NSUInteger index = [self.textFields indexOfObject:textField];
    
    // Find the next text field, If we reach the end of array of text fields, go to the first one.
    if (index < self.textFields.count - 1) {
        ++index;
    }
    else
        index = 0;
    
    // Return the next textField
    UITextField *nextTextField = [self.textFields objectAtIndex:index];
    
    return nextTextField;
}

// Trim the input string be removing leading and trailing white spaces and return the result.
- (NSString *)stringTrimmedForLeadingAndTrailingWhiteSpaceFromString:(NSString *)string{
    // TODO: To be implemented from tutorial.
    return string;
}

- (void)validateTextField:(UITextField *)textField{
    // We don't want to do validation on empty string. This is out design here. If you intend to invalidate empty fields -- i.e. fields are required, you can also do the validation on empty string.
    NSString *text = textField.text;
    
    // We use the rightView of the textField for feedback.
    UIImageView *rightImageView = (UIImageView *)textField.rightView;
    
    // If user completely deletes a field, we don't want to display anything.
    if (! text.length) {
        rightImageView = nil;
        textField.rightViewMode = UITextFieldViewModeNever;
    }
    else
    {
        // Before we start, in our design, we want to ingore leading and trailing whiteSpaces, so trim the text field text and removing leading and trialing whitespaces and update UI
        NSString *trimmedString = [self stringTrimmedForLeadingAndTrailingWhiteSpaceFromString:text];
        textField.text = trimmedString;
        
        // Do the validation on the trimmed text. First, find the index of the text field so that we can  match it with its validation pattern
        
        NSUInteger index = [self.textFields indexOfObject:textField];
        NSString *validationPattern = [self.validations objectAtIndex:index];
        
        // By default, the rightImageView is nil, If it is nil,  it means it the first time we are doing validation on this field, so create an image view and put it there.
        if (! rightImageView) {
            // Create an image view that fits the right view size
            rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30.0, 30.0)];
            textField.rightView = rightImageView;
        }
        
        // Perform the validation
        BOOL didValidation = [self validateString:trimmedString withPattern:validationPattern];
        
        // Base on weather it validates or not, provide a feedback in UI.
        if (didValidation) {
            rightImageView.image = [UIImage imageNamed:@"checkmark.png"];
            textField.rightViewMode = UITextFieldViewModeUnlessEditing;
        } else {
            rightImageView.image = [UIImage imageNamed:@"exclamation.png"];
            textField.rightViewMode = UITextFieldViewModeUnlessEditing;
        }
    }
}

// Validate the input string with the given pattern and return the result as a boolean.
- (BOOL)validateString:(NSString *)string withPattern:(NSString *)validatePattern{
    // TODO: To be implemented from tutorial.
    return NO;
}

@end
