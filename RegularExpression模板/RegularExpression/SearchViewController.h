//
//  SearchViewController.h
//  RegularExpression
//
//  Created by ad on 27/05/2017.
//
//

#import <UIKit/UIKit.h>

#define kSearchCaseSensitiveKey @"SearchCaseSensitiveKey"
#define kSearchWholeWordsKey @"SearchWholeWordsKey"
#define kReplacementKey @"ReplacementKey"
@protocol SearchViewControllerDelegate;

@interface SearchViewController : UITableViewController

@property (weak, nonatomic) id<SearchViewControllerDelegate> delegate;

@property (strong, nonatomic) NSString *searchString;
@property (strong, nonatomic) NSDictionary *searchOptions;
@property (strong, nonatomic) NSString *replacementString;

@end

@protocol SearchViewControllerDelegate <NSObject>

// Return self, the search string, the search options and replacement string (if any).
// If there is no replacement string, it will be nil.
- (void)controller:(SearchViewController *)controller didFinishWithSearchString:(NSString *)string options:(NSDictionary *)options replacement:(NSString *)replacement;

@end
