//
//  PageViewController.m
//  ScrollView
//
//  Created by ad on 06/07/2017.
//
//  详细博文：https://github.com/pro648/tips/wiki/UIScrollView%E7%9A%84%E7%94%A8%E6%B3%95

#import "PageViewController.h"

@interface PageViewController () <UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) NSArray *contentList;
@property (strong, nonatomic) UIPageControl *pageControl;

@end

#define pageControlHeight 70

@implementation PageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1.初始化数组
    self.contentList = @[@"one", @"two", @"three", @"four", @"five"];
    
    // 2.将scrollView和pageControl添加到view 设定控制器背景颜色
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.pageControl];
    self.view.backgroundColor = [UIColor blackColor];
    
    // 3.为scrollView每一页添加图片
    for (NSUInteger i=0; i<self.contentList.count; ++i) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.scrollView.frame) * i, 0, CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame))];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = [UIImage imageNamed:self.contentList[i]];
        [self.scrollView addSubview:imageView];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Properties

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, pageControlHeight, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 2*pageControlHeight)];
        _scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame) * self.contentList.count, CGRectGetHeight(self.view.frame) - 2*pageControlHeight);
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - pageControlHeight, CGRectGetWidth(self.view.frame), pageControlHeight)];
        _pageControl.numberOfPages = self.contentList.count;
        _pageControl.currentPage = 0;
        [_pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    }
    return _pageControl;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = CGRectGetWidth(self.scrollView.frame);
    NSUInteger page = floor((scrollView.contentOffset.x - pageWidth/2)/pageWidth) + 1;
    self.pageControl.currentPage = page;
}

#pragma mark - IBAction

- (void)changePage:(id)sener {
    NSUInteger page = self.pageControl.currentPage;
    CGRect bounds = self.scrollView.bounds;
    bounds.origin.x = CGRectGetWidth(bounds) * page;
    bounds.origin.y = self.scrollView.frame.origin.y;
    [self.scrollView scrollRectToVisible:bounds animated:YES];
}

@end
