//  ViewController.m
//  WebKit
//
//  Created by pro648 on 2018/12/24
//  Copyright © 2018 pro648. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
#import "ContentsViewController.h"
#import "URLSchemeHandler.h"
#import "UIDelegateHandler.h"
#import "NavigationDelegateHandler.h"
#import "ScriptMessageHandler.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *forwardButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *contentsButton;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) WKWebViewConfiguration *webConfiguration;
@property (nonatomic, strong) UIBarButtonItem *refreshButton;
@property (nonatomic, strong) UIBarButtonItem *stopLoadingButton;
@property (nonatomic, strong) NSArray *messageBody;

@property (nonatomic, strong) NavigationDelegateHandler *navigationDelegateHandler;
@property (nonatomic, strong) UIDelegateHandler *uiDelegateHandler;
@property (nonatomic, strong) ScriptMessageHandler *scriptMessageHandler;
@property (nonatomic, strong) URLSchemeHandler *urlSchemeHandler;

@end

static void *webViewContext = &webViewContext;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"pro648";
    self.backButton.enabled = NO;
    self.forwardButton.enabled = NO;
    
    [self.view insertSubview:self.webView belowSubview:self.progressView];
    
    self.webView.translatesAutoresizingMaskIntoConstraints = NO;
    UILayoutGuide *layoutGuide = self.view.safeAreaLayoutGuide;
    
    [self.webView.topAnchor constraintEqualToAnchor:layoutGuide.topAnchor].active = YES;
    [self.webView.leadingAnchor constraintEqualToAnchor:layoutGuide.leadingAnchor].active = YES;
    [self.webView.bottomAnchor constraintEqualToAnchor:self.toolBar.topAnchor].active = YES;
    [self.webView.trailingAnchor constraintEqualToAnchor:layoutGuide.trailingAnchor].active = YES;
    
    [self.webView addObserver:self forKeyPath:@"hasOnlySecureContent" options:NSKeyValueObservingOptionNew context:webViewContext];
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:webViewContext];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:webViewContext];
    [self.webView addObserver:self forKeyPath:@"loading" options:NSKeyValueObservingOptionNew context:webViewContext];
    [self.scriptMessageHandler addObserver:self forKeyPath:@"messageBody" options:NSKeyValueObservingOptionNew context:NULL];
    
    
     // Local HTML
     NSURL *htmlURL = [[NSBundle mainBundle] URLForResource:@"WKWebView - NSHipster" withExtension:@"htm"];
    
     // Create WebView HTML
//     NSURL *htmlURL = [[NSBundle mainBundle] URLForResource:@"web" withExtension:@"htm"];
    
     // Custom url Scheme HTML
//    NSURL *htmlURL = [[NSBundle mainBundle] URLForResource:@"customScheme" withExtension:@"htm"];
    
     NSURL *baseURL = [htmlURL URLByDeletingLastPathComponent];
     NSString *htmlString = [NSString stringWithContentsOfURL:htmlURL
     encoding:NSUTF8StringEncoding
     error:NULL];
     [self.webView loadHTMLString:htmlString baseURL:baseURL];
     
    
    /*
    // Web Content
//    NSURL *myURL = [NSURL URLWithString:@"https://en.wikipedia.org/w/index.php?title=San_Francisco&mobileaction=toggle_view_desktop"];
    NSURLRequest *request = [NSURLRequest requestWithURL:myURL
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:30];
    [self.webView loadRequest:request];
     */
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.webView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id _Nullable userAgent, NSError * _Nullable error) {
        NSLog(@"%@",userAgent);
    }];
}

#pragma mark - IBAction

- (IBAction)backButtonTapped:(id)sender {
    [self.webView goBack];
}

- (IBAction)forwardButtonTapped:(id)sender {
    [self.webView goForward];
}

- (void)refreshButtonTapped:(id)sender {
    [self.webView reload];
}

- (void)stopLoadingButtonTapped:(id)sender {
    [self.webView stopLoading];
}

- (IBAction)contentsButtonTapped:(id)sender {
    ContentsViewController *contentsVC = [[ContentsViewController alloc] init];
    contentsVC.messageBody = self.messageBody.copy;
    [contentsVC setDidSelectEntry:^(Entry * _Nonnull entry) {
        NSURLRequest *request = [NSURLRequest requestWithURL:entry.url];
        [self.webView loadRequest:request];
    }];
    [self presentViewController:contentsVC
                       animated:YES
                     completion:nil];
}

- (IBAction)takeSnapShot:(UIBarButtonItem *)sender {
    WKSnapshotConfiguration *shotConfiguration = [[WKSnapshotConfiguration alloc] init];
    shotConfiguration.rect = CGRectMake(0, 0, self.webView.bounds.size.width, self.webView.bounds.size.height);
    
    [self.webView takeSnapshotWithConfiguration:shotConfiguration
                              completionHandler:^(UIImage * _Nullable snapshotImage, NSError * _Nullable error) {
                                  // 保存截图至相册，需要在info.plist中添加NSPhotoLibraryAddUsageDescription key和描述。
                                  UIImageWriteToSavedPhotosAlbum(snapshotImage, NULL, NULL, NULL);
                              }];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (context == webViewContext && [keyPath isEqualToString:@"hasOnlySecureContent"]) {
        BOOL onlySecureContent = [[change objectForKey:NSKeyValueChangeNewKey] boolValue];
        NSLog(@"onlySecureContent:%@",onlySecureContent ? @"YES" : @"NO");
    } else if (context == webViewContext && [keyPath isEqualToString:@"title"]) {
        self.navigationItem.title = change[NSKeyValueChangeNewKey];
    } else if (context == webViewContext && [keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.hidden = [change[NSKeyValueChangeNewKey] isEqualToNumber:@1];
        
        CGFloat progress = [change[NSKeyValueChangeNewKey] floatValue];
        self.progressView.progress = progress;
    } else if (context == webViewContext && [keyPath isEqualToString:@"loading"]) {
        BOOL loading = [change[NSKeyValueChangeNewKey] boolValue];
        // 加载完成后，右侧为刷新按钮；加载过程中，右侧为暂停按钮。
        self.navigationItem.rightBarButtonItem = loading ? self.stopLoadingButton : self.refreshButton;
        
        self.backButton.enabled = self.webView.canGoBack;
        self.forwardButton.enabled = self.webView.canGoForward;
    } else if ([keyPath isEqualToString:@"messageBody"]) {
        self.messageBody = (NSArray *)change[NSKeyValueChangeNewKey];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - Getters & Setters

- (NavigationDelegateHandler *)navigationDelegateHandler {
    if (!_navigationDelegateHandler) {
        _navigationDelegateHandler = [[NavigationDelegateHandler alloc] init];
        _navigationDelegateHandler.backButton = self.backButton;
        _navigationDelegateHandler.forwardButton = self.forwardButton;
    }
    return _navigationDelegateHandler;
}

- (UIDelegateHandler *)uiDelegateHandler {
    if (!_uiDelegateHandler) {
        _uiDelegateHandler = [[UIDelegateHandler alloc] init];
    }
    return _uiDelegateHandler;
}

- (ScriptMessageHandler *)scriptMessageHandler {
    if (!_scriptMessageHandler) {
        _scriptMessageHandler = [[ScriptMessageHandler alloc] init];
    }
    return _scriptMessageHandler;
}

- (URLSchemeHandler *)urlSchemeHandler {
    if (!_urlSchemeHandler) {
        _urlSchemeHandler = [[URLSchemeHandler alloc] init];
    }
    return _urlSchemeHandler;
}

- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:self.webConfiguration];
        _webView.allowsBackForwardNavigationGestures = YES;
//        _webView.customUserAgent = @"pro648";
        _webView.navigationDelegate = self.navigationDelegateHandler;
        _webView.UIDelegate = self.uiDelegateHandler;
    }
    return _webView;
}

- (WKWebViewConfiguration *)webConfiguration {
    if (!_webConfiguration) {
        _webConfiguration = [[WKWebViewConfiguration alloc] init];
        
        /*
        // 偏好设置 设置最小字体
        WKPreferences *preferences = [[WKPreferences alloc] init];
        preferences.minimumFontSize = 30;
        _webConfiguration.preferences = preferences;
        */
         
        // 识别网页中的电话号码
        _webConfiguration.dataDetectorTypes = WKDataDetectorTypePhoneNumber;
        
        // Web视图内容完全加载到内存之前，禁止呈现。
        _webConfiguration.suppressesIncrementalRendering = YES;
        
//        _webConfiguration.applicationNameForUserAgent = @"pro648";
        
        // 隐藏wikipedia左边缘和contents表格
        NSURL *hideTableOfContentsScriptURL = [[NSBundle mainBundle] URLForResource:@"hide" withExtension:@"js"];
        NSString *hideTableOfContentsScriptString = [NSString stringWithContentsOfURL:hideTableOfContentsScriptURL
                                                                             encoding:NSUTF8StringEncoding error:NULL];
        WKUserScript *hideTableOfContentsScript = [[WKUserScript alloc] initWithSource:hideTableOfContentsScriptString
                                                                         injectionTime:WKUserScriptInjectionTimeAtDocumentStart
                                                                      forMainFrameOnly:YES];
        
        // 获取contents表格内容
        NSString *fetchTableOfContentsScriptString = [NSString stringWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"fetch" withExtension:@"js"] encoding:NSUTF8StringEncoding error:NULL];
        WKUserScript *fetchTableOfContentsScript = [[WKUserScript alloc] initWithSource:fetchTableOfContentsScriptString
                                                                          injectionTime:WKUserScriptInjectionTimeAtDocumentEnd
                                                                       forMainFrameOnly:YES];
        
        WKUserContentController *userContentController = [[WKUserContentController alloc] init];
        [userContentController addUserScript:hideTableOfContentsScript];
        [userContentController addUserScript:fetchTableOfContentsScript];
        [userContentController addScriptMessageHandler:self.scriptMessageHandler name:@"didFetchTableOfContents"];
        
        // 最后，将userContentController添加到WKWebViewConfiguration
        _webConfiguration.userContentController = userContentController;
        
        // 添加要自定义的url scheme
        [_webConfiguration setURLSchemeHandler:self.urlSchemeHandler forURLScheme:@"custom-scheme"];
    }
    return _webConfiguration;
}

- (UIBarButtonItem *)refreshButton {
    if (!_refreshButton) {
        _refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                       target:self
                                                                       action:@selector(refreshButtonTapped:)];
    }
    return _refreshButton;
}

- (UIBarButtonItem *)stopLoadingButton {
    if (!_stopLoadingButton) {
        _stopLoadingButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop
                                                                           target:self
                                                                           action:@selector(stopLoadingButtonTapped:)];
    }
    return _stopLoadingButton;
}

- (void)dealloc {
    [_webView removeObserver:self
                  forKeyPath:@"hasOnlySecureContent"
                     context:webViewContext];
    [_webView removeObserver:self
                  forKeyPath:@"title"
                     context:webViewContext];
    [_webView removeObserver:self
                  forKeyPath:@"loading"
                     context:webViewContext];
    [_webView removeObserver:self
                  forKeyPath:@"estimatedProgress"
                     context:webViewContext];
}

@end
