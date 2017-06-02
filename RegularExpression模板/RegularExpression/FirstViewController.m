//
//  FirstViewController.m
//  RegularExpression
//
//  Created by ad on 27/05/2017.
//
//  demo详细介绍：https://github.com/pro648/tips/wiki/%E6%AD%A3%E5%88%99%E8%A1%A8%E8%BE%BE%E5%BC%8FNSRegularExpression

#import "FirstViewController.h"
#import "SearchViewController.h"

@interface FirstViewController () <UITextViewDelegate, SearchViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *searchBarButton;
@property (strong, nonatomic) NSString *lastSearchString;
@property (strong, nonatomic) NSDictionary *lastSearchOptions;
@property (strong, nonatomic) NSString *lastReplacementString;

@end

// TODO: To be implemented from tutorial.
static NSString * const timePattern = @".";
static NSString * const datePattern = @".";
static NSString * const locationPattern = @".";


@implementation FirstViewController

#pragma mark
#pragma mark View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SearchViewControllerSegue"]) {
        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        SearchViewController *searchVC = navController.viewControllers.firstObject;
        
        searchVC.delegate = self;
        searchVC.searchString = self.lastSearchString;
        searchVC.searchOptions = self.lastSearchOptions;
        searchVC.replacementString = self.lastReplacementString;
    }
}

#pragma mark
#pragma mark IBAction

- (IBAction)findingInterestingData:(UIBarButtonItem *)sender {
    [self underlineTextWithPattern:timePattern options:NSRegularExpressionCaseInsensitive];
    [self underlineTextWithPattern:datePattern options:NSRegularExpressionCaseInsensitive];
    [self underlineTextWithPattern:locationPattern options:0];
}

#pragma mark
#pragma mark SearchViewControllerDelegate

- (void)controller:(SearchViewController *)controller didFinishWithSearchString:(NSString *)string options:(NSDictionary *)options replacement:(NSString *)replacement
{
    if (![string isEqualToString:self.lastSearchString] ||
        ![options isEqual:self.lastSearchOptions] ||
        ![replacement isEqualToString:self.lastSearchString]) {
        // Keep a reference
        self.lastSearchString = string;
        self.lastSearchOptions = options;
        self.lastReplacementString = replacement;
        
        // 取消所有高亮显示
        [self removeAllHighlightedTextInTextView:self.textView];
        
        if (replacement) {
            // 搜索并替换
            [self searchAndReplaceText:string withText:replacement inTextView:self.textView options:options];
        }
        else
        {
            // 搜索
            [self searchText:string inTextView:self.textView options:options];
        }
    }
}

#pragma mark
#pragma mark Manage search to find and replace.

// Search for a searchString in the given text view with search options.
- (void)searchText:(NSString *)string inTextView:(UITextView *)textView options:(NSDictionary *)options{
    // TODO: To be implemented from tutorial.
}

// Search for a searchString and replace it with the replacementString in the given text view with search options.
- (void)searchAndReplaceText:(NSString *)string withText:(NSString *)replacement inTextView:(UITextView *)textView options:(NSDictionary *)options{
    // TODO: To be implemented from tutorial.
}

#pragma mark
#pragma mark Helper Method

// Create a regular expression with given string and options
- (NSRegularExpression *)regularExpressionWithString:(NSString *)string options:(NSDictionary *)options
{
    return nil;
}

// Return range of text in text view that is visible
- (NSRange)visibleRangeOfTextView:(UITextView *)textView
{
    CGRect bounds = textView.bounds;
    UITextPosition *start = [textView characterRangeAtPoint:bounds.origin].start;
    UITextPosition *end = [textView characterRangeAtPoint:CGPointMake(CGRectGetMaxX(bounds), CGRectGetMaxY(bounds))].end;
    
    NSRange visibleRange = NSMakeRange([textView offsetFromPosition:textView.beginningOfDocument toPosition:start], [textView offsetFromPosition:start toPosition:end]);
    
    return visibleRange;
}

// Compare the two ranges and return YES if range1 contains range2
bool NSRangeContainsRange (NSRange range1, NSRange range2){
    BOOL contains = NO;
    if (range1.location < range2.location && range1.location + range1.length > range2.location + range2.length) {
        contains = YES;
    }
    
    return contains;
}

// Remove all highlighted text of NSAttributedString in a given UITextView
- (void)removeAllHighlightedTextInTextView:(UITextView *)textView{
    NSMutableAttributedString *mutableAttributedString = textView.attributedText.mutableCopy;
    NSRange wholeRange = NSMakeRange(0, mutableAttributedString.length);
    [mutableAttributedString addAttribute:NSBackgroundColorAttributeName value:[UIColor clearColor] range:wholeRange];
    textView.attributedText = mutableAttributedString.copy;
}

- (void)highlightMatches:(NSArray *)matches{
    __block NSMutableAttributedString *mutableAttributedString = self.textView.attributedText.mutableCopy;
    
    [matches enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSTextCheckingResult class]]) {
            NSTextCheckingResult *result = (NSTextCheckingResult *)obj;
            NSRange matchRange = result.range;
            [mutableAttributedString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:matchRange];
            [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:matchRange];
        }
    }];
    self.textView.attributedText = mutableAttributedString.copy;
}

- (void)underlineTextWithPattern:(NSString *)pattern options:(NSRegularExpressionOptions)options{
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:options error:&error];
    if (error) {
        NSLog(@"Unable to create regex.");
    }
    
    NSString *string = self.textView.text;
    NSArray *matches = [regex matchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, string.length)];
    [self highlightMatches:matches];
}

@end
