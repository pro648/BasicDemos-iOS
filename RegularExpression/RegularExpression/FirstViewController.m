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

static NSString * const timePattern = @"\\d{1,2}\\s*(am|pm)";
static NSString * const datePattern = @"(\\d{1,2}[-/.]\\d{1,2}[-/.]\\d{1,2})|(Jan(uary)?|Feb(ruary)?|Mar(ch)?|Apr(il)?|May|Jun(e)?|Jul(y)?|Aug(ust)?|Sep(tember)?|Oct(ober)?|Nov(ember)?|Dec(ember)?)\\s*\\d{1,2}(st|nd|rd|th)?+[,]\\s*\\d{4}";
static NSString * const locationPattern = @"[a-zA-Z]+[,]\\s*([A-Z]{2})";

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
    // 1.Range of visible text
    NSRange visibleRange = [self visibleRangeOfTextView:textView];
    
    // 2.Get a mutable sub-range of attributed string of the text view that is visible.
    NSMutableAttributedString *visibleAttributedText = [textView.attributedText attributedSubstringFromRange:visibleRange].mutableCopy;
    
    // Get the string of the attributed text.
    NSString *visibleText = visibleAttributedText.string;
    
    // 3.Create a new range for the visible text. This is different from visibleRange. visibleRange is a portion of all textView that is visible, but visibleTextRange is only for visibleText, so it starts at 0 and its length is the length of visibleText.
    NSRange visibleTextRange = NSMakeRange(0, visibleText.length);
    
    // 4.Call the convenient method to create a regex for us with the options we have.
    NSRegularExpression *regex = [self regularExpressionWithString:string options:options];
    
    // 5.Find matches
    NSArray *matches = [regex matchesInString:visibleText options:NSMatchingReportCompletion range:visibleTextRange];
    
    // 6.Iterate through the matches and highlights them.
    for (NSTextCheckingResult *result in matches) {
        NSRange matchRange = result.range;
        [visibleAttributedText addAttribute:NSBackgroundColorAttributeName value:[UIColor yellowColor] range:matchRange];
    }
    
    // 注释5和6可以合并在一起，如下：
    /*
    [regex enumerateMatchesInString:visibleText options:NSMatchingReportCompletion range:visibleTextRange usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        NSRange matchRange = result.range;
        [visibleAttributedText addAttribute:NSBackgroundColorAttributeName value:[UIColor yellowColor] range:matchRange];
    }];
     */
    
    // 7.Replace the range of the attributed string that we just highlighted. First, create a CFRange from the NSRange of the visible range.
    CFRange visibleRange_CF = CFRangeMake(visibleRange.location, visibleRange.length);
    
    // Get a mutable copy of the attributed text of the text view.
    NSMutableAttributedString *textViewAttributedString = self.textView.attributedText.mutableCopy;
    
    // Replace the visible range.
    CFAttributedStringReplaceAttributedString((__bridge CFMutableAttributedStringRef)textViewAttributedString, visibleRange_CF, (__bridge CFAttributedStringRef)(visibleAttributedText));
    
    // 8.Update UI.
    textView.attributedText = textViewAttributedString;
}

// Search for a searchString and replace it with the replacementString in the given text view with search options.
- (void)searchAndReplaceText:(NSString *)string withText:(NSString *)replacement inTextView:(UITextView *)textView options:(NSDictionary *)options{
    // Text before replacement
    NSString *beforeText = textView.text;
    
    // Create a range for it, We do the replacement on the whole range of the text view, not noly a portion of it.
    NSRange range = NSMakeRange(0, beforeText.length);
    
    // Call the convenience method to create a regex for us with the options we have.
    NSRegularExpression *regex = [self regularExpressionWithString:string options:options];
    
    // Call the NSRegularExpression method to do the replacement for us.
    NSString *afterText = [regex stringByReplacingMatchesInString:beforeText options:0 range:range withTemplate:replacement];
    
    // Update UI
    textView.text = afterText;
}

#pragma mark
#pragma mark Helper Method

// Create a regular expression with given string and options
- (NSRegularExpression *)regularExpressionWithString:(NSString *)string options:(NSDictionary *)options
{
    // Create a regular expression
    BOOL isCaseSensitive = [[options objectForKey:kSearchCaseSensitiveKey] boolValue];
    BOOL isWholeWords = [[options objectForKey:kSearchWholeWordsKey] boolValue];
    
    NSRegularExpressionOptions regexOptions = isCaseSensitive ? 0 : NSRegularExpressionCaseInsensitive;
    NSString *placeHolder = isWholeWords ? @"\\b%@\\b" : @"%@" ;
    NSString *pattern = [NSString stringWithFormat:placeHolder,string];
    
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:regexOptions error:&error];
    if (error) {
        NSLog(@"Could't create regex with given string and options");
    }
    
    return regex;
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

#pragma mark 
#pragma mark UIScrollViewDelegate

// Called when the user finishes scrolling the content.
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    if (CGPointEqualToPoint(velocity, CGPointZero)) {
        if (self.lastSearchString && self.lastSearchOptions && !self.lastReplacementString) {
            [self searchText:self.lastSearchString inTextView:self.textView options:self.lastSearchOptions];
        }
    }
}

// Called when the scroll view has ended decelerating the scrolling movement.
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (self.lastSearchString && self.lastSearchOptions && !self.lastReplacementString) {
        [self searchText:self.lastSearchString inTextView:self.textView options:self.lastSearchOptions];
    }
}

@end
