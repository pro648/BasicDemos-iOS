//
//  ViewController.m
//  RefreshControl
//
//  Created by ad on 27/03/2017.
//
//  demo介绍： https://github.com/pro648/tips/wiki/%E5%9C%A8UIScrollView%E3%80%81UICollectionView%E5%92%8CUITableView%E4%B8%AD%E6%B7%BB%E5%8A%A0UIRefreshControl%E5%AE%9E%E7%8E%B0%E4%B8%8B%E6%8B%89%E5%88%B7%E6%96%B0

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (assign, nonatomic) BOOL available;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 1 先判断系统版本
    if ([NSProcessInfo.processInfo isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion){10,0,0}])
    {
        // 2 初始化
        UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
        
        // 3.1 配置刷新控件
        refreshControl.tintColor = [UIColor brownColor];
        NSDictionary *attributes = @{NSForegroundColorAttributeName : [UIColor redColor]};
        refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull To Refresh" attributes:attributes];
        // 3.2 添加响应事件
        [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
        
        // 4 把创建的refreshControl赋值给scrollView的refreshControl属性
        self.scrollView.refreshControl = refreshControl;
    }
}

- (void)refresh:(UIRefreshControl *)sender
{
    self.available = ! self.available;
    self.secondLabel.hidden = self.available;
    
    // 停止刷新
    [sender endRefreshing];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
