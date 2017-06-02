//
//  SearchViewController.m
//  RegularExpression
//
//  Created by ad on 27/05/2017.
//
//  demo详细介绍：https://github.com/pro648/tips/wiki/%E6%AD%A3%E5%88%99%E8%A1%A8%E8%BE%BE%E5%BC%8FNSRegularExpression

#import "SearchViewController.h"

@interface SearchViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UITextField *replaceTextField;
@property (weak, nonatomic) IBOutlet UISwitch *replaceSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *caseSensitiveSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *wholeWordsSwitch;
@property (strong, nonatomic) NSMutableDictionary *options;

@end

@implementation SearchViewController

#pragma mark
#pragma mark View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchTextField.text = self.searchString;
    if (! self.searchString) {
        [self.searchTextField becomeFirstResponder];
    }
    
    if (self.searchOptions) {
        // 根据上一次的搜索进行调整
        self.options = self.searchOptions.mutableCopy;
        self.replaceTextField.text = self.replacementString;
        
        BOOL isReplace = [[self.options objectForKey:kReplacementKey] boolValue];
        [self.replaceSwitch setOn:isReplace];
        self.replaceTextField.enabled = isReplace;
        
        BOOL isCaseSensitive = [[self.options objectForKey:kSearchCaseSensitiveKey] boolValue];
        [self.caseSensitiveSwitch setOn:isCaseSensitive];
        
        BOOL isWholeWords = [[self.options objectForKey:kSearchWholeWordsKey] boolValue];
        [self.wholeWordsSwitch setOn:isWholeWords];
    }
    else
    {
        // 初始化options
        self.options = [NSMutableDictionary dictionary];
        
        // 初始值
        NSNumber *isReplace = [NSNumber numberWithBool:self.replaceSwitch.isOn];
        [self.options setObject:isReplace forKey:kReplacementKey];
        self.replaceTextField.enabled = isReplace.boolValue;
        
        NSNumber *isCaseSensitive = [NSNumber numberWithBool:self.caseSensitiveSwitch.isOn];
        [self.options setObject:isCaseSensitive forKey:kSearchCaseSensitiveKey];
        
        NSNumber *isWholeWords = [NSNumber numberWithBool:self.wholeWordsSwitch.isOn];
        [self.options setObject:isWholeWords forKey:kSearchWholeWordsKey];
    }
    
    // 双击时隐藏键盘
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.tableView addGestureRecognizer:doubleTap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark IBAction

- (void)dismissKeyboard:(id)sender{
    if ([self.searchTextField isFirstResponder]) {
        [self.searchTextField resignFirstResponder];
    }
    else if ([self.replaceTextField isFirstResponder])
    {
        [self.replaceTextField resignFirstResponder];
    }
}

- (IBAction)closeButtonTapped:(UIBarButtonItem *)sender {
    // Dismiss the view controller.
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)searchButtonTapped:(UIBarButtonItem *)sender {
    self.searchString = self.searchTextField.text;
    
    if (self.replaceTextField.enabled) {
        self.replacementString = self.replaceTextField.text;
    }
    
    self.searchOptions = self.options.copy;
    // Dismiss the view controller
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.searchString && self.searchOptions) {
            // 在代理响应该方法时传值
            if ([self.delegate respondsToSelector:@selector(controller:didFinishWithSearchString:options:replacement:)]) {
                [self.delegate controller:self didFinishWithSearchString:self.searchString options:self.searchOptions replacement:self.replacementString];
                NSLog(@"after delegate");
            }
        }
    }];
}

- (IBAction)replaceSwitchToggled:(UISwitch *)sender {
    NSNumber *isReplace = [NSNumber numberWithBool:sender.isOn];
    [self.options setObject:isReplace forKey:kReplacementKey];
    
    self.replaceTextField.enabled = isReplace.boolValue;
    
    // replaceTextField禁用时，不再传送searchString的值
    if (! sender.isOn) {
        self.replacementString = nil;
        self.replaceTextField.text = nil;
    }
}
- (IBAction)caseSensitiveSwitchToggled:(UISwitch *)sender {
    NSNumber *isCaseSensitive = [NSNumber numberWithBool:sender.isOn];
    [self.options setObject:isCaseSensitive forKey:kSearchCaseSensitiveKey];
}
- (IBAction)wholeWordsSwitchToggled:(UISwitch *)sender {
    NSNumber *isWholeWords = [NSNumber numberWithBool:sender.isOn];
    [self.options setObject:isWholeWords forKey:kSearchWholeWordsKey];
}

#pragma mark
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:self.searchTextField]) {
        self.searchString = textField.text;
    } else if ([textField isEqual:self.replaceTextField]){
        self.replacementString = textField.text;
    }
    
    [textField resignFirstResponder];
    
    return YES;
}

@end
