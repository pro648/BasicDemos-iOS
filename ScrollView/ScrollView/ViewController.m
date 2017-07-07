//
//  ViewController.m
//  ScrollView
//
//  Created by ad on 03/07/2017.
//
//  详细博文：https://github.com/pro648/tips/wiki/UIScrollView%E7%9A%84%E7%94%A8%E6%B3%95

#import "ViewController.h"

@interface ViewController () <UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.imageView];
    
    // 设定最小缩放比
    [self setZoomScale];
    
    // 添加双击手势
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.scrollView addGestureRecognizer:doubleTap];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    // 1.移除子视图
    for (UIView *view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }
    
    // 2.初始化imageView 将其添加到scrollView 设置contentSize
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image"]];
    [self.scrollView addSubview:self.imageView];
    self.scrollView.contentSize = self.imageView.frame.size;
    
    // 3.重设minimumZoomScale
    [self setZoomScale];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Properties

- (UIImageView *)imageView {
    if (!_imageView) {
        UIImage *image = [UIImage imageNamed:@"image"];
        // 1.初始化imageView
        _imageView = [[UIImageView alloc] initWithImage:image];
    }
    return _imageView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        // 2.初始化、配置scrollView
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.backgroundColor = [UIColor blackColor];
        _scrollView.contentSize = self.imageView.frame.size;
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scrollView.contentOffset = CGPointMake(1000, 450);
        
        _scrollView.delegate = self;
//        _scrollView.minimumZoomScale = 0.1;
//        _scrollView.maximumZoomScale = 4.0;
//        _scrollView.zoomScale = 1.0;
    }
    return _scrollView;
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    // 计算imageView缩小到最小时 imageView与屏幕边缘距离
    CGFloat horizontalPadding = CGRectGetWidth(self.imageView.frame) < CGRectGetWidth(scrollView.frame) ? (CGRectGetWidth(scrollView.frame) - CGRectGetWidth(self.imageView.frame)) / 2 : 0 ;
    CGFloat verticalPadding = CGRectGetHeight(self.imageView.frame) < CGRectGetHeight(scrollView.frame) ? (CGRectGetHeight(scrollView.frame) - CGRectGetHeight(self.imageView.frame)) / 2 : 0 ;
    scrollView.contentInset = UIEdgeInsetsMake(verticalPadding, horizontalPadding, verticalPadding, horizontalPadding);
}

#pragma mark - Help Method

- (void)setZoomScale {
    CGFloat widthScale = CGRectGetWidth(self.scrollView.frame) / CGRectGetWidth(self.imageView.frame);
    CGFloat heightScale = CGRectGetHeight(self.scrollView.frame) / CGRectGetHeight(self.imageView.frame);
    
    self.scrollView.minimumZoomScale = MIN(widthScale, heightScale);
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)doubleTap {
    if (self.scrollView.zoomScale > self.scrollView.minimumZoomScale) {
        // 视图大于最小视图时 双击将视图缩小至最小
        [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
    }
    else
    {
        /*
        // 视图为最小时 双击将视图放大至最大
        [self.scrollView setZoomScale:self.scrollView.maximumZoomScale animated:YES];
         */
        
        // 1.获取点击位置
        CGPoint touchPoint = [doubleTap locationInView:self.imageView];
        // 2.获取要显示的imageView区域
        CGRect zoomRect = [self zoomRectForScrollView:self.scrollView withScale:self.scrollView.maximumZoomScale withCenter:touchPoint];
        // 5.将要显示的imageView区域显示到scrollView
        [self.scrollView zoomToRect:zoomRect animated:YES];
    }
}

- (CGRect)zoomRectForScrollView:(UIScrollView *)scrollView withScale:(CGFloat)scale withCenter:(CGPoint)center {
    // 3.声明一个区域 滚动视图的宽除以放大倍数可以得到要显示imageView宽度
    CGRect zoomRect;
    zoomRect.size.width = CGRectGetWidth(scrollView.frame) / scale;
    zoomRect.size.height = CGRectGetHeight(scrollView.frame) / scale;
    
    // 4.点击位置x坐标减去1/2图像宽度，可以得到要显示imageView的原点x坐标 y坐标类似
    zoomRect.origin.x = center.x - zoomRect.size.width / 2;
    zoomRect.origin.y = center.y - zoomRect.size.height / 2;
    
    return zoomRect;
}


@end
