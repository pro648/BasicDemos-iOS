//
//  ViewController.m
//  NSURLSession1
//
//  Created by ad on 19/01/2017.
//
//  详细介绍：https://github.com/pro648/tips/wiki/NSURLSession%E7%9A%84%E4%BD%BF%E7%94%A8%EF%BC%88%E4%B8%80%EF%BC%89

#import "ViewController.h"

@interface ViewController () <NSURLSessionDelegate, NSURLSessionDownloadDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIProgressView *progressView;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UIButton *resumeButton;
@property (strong, nonatomic) NSURLSession *session;
@property (strong, nonatomic) NSURLSessionDownloadTask *downloadTask;
@property (strong, nonatomic) NSData *resumeData;   // 用于存储暂停下载时的数据

- (IBAction)cancel:(id)sender;
- (IBAction)resume:(id)sender;

@end

@implementation ViewController

#pragma mark View Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    // 第一个示例代码
//    NSURLSession *session = [NSURLSession sharedSession];
//    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:@"https://itunes.apple.com/search?term=apple&media=software"] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//        NSLog(@"%@",json);
//    }];
//    [dataTask resume];
    
    // 添加观察者
    [self addObserver:self forKeyPath:@"resumeData" options:NSKeyValueObservingOptionNew context:NULL];
    [self addObserver:self forKeyPath:@"downloadTask" options:NSKeyValueObservingOptionNew context:NULL];
    
    // 隐藏点击按钮
    self.cancelButton.hidden = YES;
    self.resumeButton.hidden = YES;
    
    // 创建下载任务
    self.downloadTask = [self.session downloadTaskWithURL:[NSURL URLWithString:@"https://cdn.tutsplus.com/mobile/uploads/2013/12/sample.jpg"]];
    
    // 执行任务
    [self.downloadTask resume];
}

- (void)dealloc {
    // 移除观察者。
    [self removeObserver:self forKeyPath:@"resumeData"];
    [self removeObserver:self forKeyPath:@"downloadTask"];
}

#pragma mark Getters & Setters
- (NSURLSession *)session
{
    if (! _session)
    {
        // 创建会话配置
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        // 创建会话
        _session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
    }
    
    return _session;
}

- (void)setProgressView:(UIProgressView *)progressView
{
    if (_progressView != progressView)
    {
        _progressView = progressView;
        _progressView.progress = 0;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark IBAction
- (IBAction)cancel:(id)sender
{
    if (! self.downloadTask) return;
    
    [self.downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
        if (resumeData)
        {
            [self setResumeData:resumeData];
            [self setDownloadTask:nil];
        }
    }];
}

- (IBAction)resume:(id)sender
{
    if (! self.resumeData) return;
    
    // 创建任务
    self.downloadTask = [self.session downloadTaskWithResumeData:self.resumeData];
    
    // 执行任务
    [self.downloadTask resume];
    
    // 清除resumeData数据
    [self setResumeData:nil];
}

#pragma mark Session Download Delegate Method
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSData *data = [NSData dataWithContentsOfURL:location];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.progressView.hidden = YES;     // 下载完成后隐藏进度条
        self.cancelButton.hidden = YES;     // 下载完成后隐藏Cancel按钮
        self.imageView.image = [UIImage imageWithData:data];
    });
    
    // 销毁会话
    [session finishTasksAndInvalidate];
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes
{
    // 输出NSLog所在行和方法名称
    NSLog(@"%d %s",__LINE__ ,__PRETTY_FUNCTION__);
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    float progress = (double) totalBytesWritten / totalBytesExpectedToWrite;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.progressView.progress = progress;
    });
}

#pragma mark Key Value Observing
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"resumeData"])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.resumeButton.hidden = (self.resumeData == nil);
        });
    }
    else if ([keyPath isEqualToString:@"downloadTask"])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.cancelButton.hidden = (self.downloadTask == nil);
        });
    }
    else
        // 如果遇到没有观察的属性，将其交由父类处理，父类可能也在观察该属性。
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

@end
