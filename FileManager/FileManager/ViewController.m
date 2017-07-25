//
//  ViewController.m
//  FileManager
//
//  Created by ad on 25/07/2017.
//
//  详细介绍：https://github.com/pro648/tips/wiki/%E4%BD%BF%E7%94%A8NSFileManager%E7%AE%A1%E7%90%86%E6%96%87%E4%BB%B6%E7%B3%BB%E7%BB%9F

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1.捆绑包目录
    NSLog(@"bundlePath %@",[NSBundle mainBundle].bundlePath);
    
    // 2.沙盒主目录
    NSString *homeDir = NSHomeDirectory();
    NSLog(@"homeDir %@",homeDir);
    
    // 3.Documents目录
    NSLog(@"Documents url %@",[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].firstObject);
    NSLog(@"Documents pathA %@",NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject);
    NSLog(@"Documents pathB %@",[homeDir stringByAppendingPathComponent:@"Documents"]);
    
    // 4.Library目录
    NSLog(@"Library url %@",[[NSFileManager defaultManager] URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask].firstObject);
    NSLog(@"Library pathA %@",NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject);
    NSLog(@"Library pathB %@",[homeDir stringByAppendingPathComponent:@"Library"]);
    
    // 5.Caches目录
    NSLog(@"Caches url %@",[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask].firstObject);
    NSLog(@"Caches path %@",NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject);
    
    // 6.tep目录
    NSLog(@"tmpA %@",NSTemporaryDirectory());
    NSLog(@"tmpB %@",[homeDir stringByAppendingPathComponent:@"tmp"]);
    
    // 创建文件管理器
    NSFileManager *sharedFM = [NSFileManager defaultManager];
    
    // 创建NSURL类型documentsURL路径 转换为NSString类型和fileReferenceURL类型路径
    NSURL *documentsURL = [sharedFM URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].firstObject;
    NSLog(@"documentsURL:%@",documentsURL);
    NSLog(@"documentsURL convert to path:%@",documentsURL.path);
    NSLog(@"fileReferenceURL:%@",[documentsURL fileReferenceURL]);
    
    // 创建NSString类型libraryPath路径 转换为NSURL类型路径
    NSString *libraryPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject;
    NSLog(@"libraryPath:%@",libraryPath);
    NSLog(@"libraryPath convert to url:%@",[NSURL fileURLWithPath:libraryPath]);
    
    // 创建目录
    NSURL *bundleIDDir = [self applicationDirectory];
    
    // 复制目录
    [self backupMyApplicationDataWithURL:bundleIDDir];
    
    // 一次枚举一个对象
    [self performSelector:@selector(enumerateOneFileAtATimeAtURL:) withObject:bundleIDDir afterDelay:0.3];
    
    // 一次枚举整个目录
    [self performSelector:@selector(enumerateAllAtOnceAtURL:) withObject:bundleIDDir afterDelay:0.3];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 创建目录
- (NSURL *)applicationDirectory {
    // 1.创建文件管理器
    NSFileManager *sharedFM = [NSFileManager defaultManager];
    
    // 2.查找Application Support目录在主目录路径
    NSArray *possibleURLs = [sharedFM URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask];
    
    NSURL *appSupportDir = nil;
    NSURL *dirPath = nil;
    if (possibleURLs.count > 0) {
        // 3.数组不为空时，使用第一个元素。
        appSupportDir = possibleURLs.firstObject;
    }
    
    // 4.如果存在appSupportDir目录 将应用的bundleIdentifier添加到文件结尾 用于创建自定义目录
    if (appSupportDir) {
        NSString *appBundleID = [[NSBundle mainBundle] bundleIdentifier];
        dirPath = [appSupportDir URLByAppendingPathComponent:appBundleID];
    }
    
    // 5.如果dirPath目录不存在 创建该目录
    NSError *error = nil;
    if (![sharedFM createDirectoryAtURL:dirPath withIntermediateDirectories:YES attributes:nil error:&error]) {
        NSLog(@"Couldn't create dirPath.error %@",error);
        return nil;
    }
    return dirPath;
}

// 复制文件
- (void)backupMyApplicationDataWithURL:(NSURL *)bundleIDDir {
    NSFileManager *sharedFM = [NSFileManager defaultManager];
    
    // 1.获得源文件、备份文件路径。如果源文件不存在，则创建源文件。
    NSURL *appDataDir = [bundleIDDir URLByAppendingPathComponent:@"Data"];
    NSURL *backupDir = [appDataDir URLByAppendingPathExtension:@"backup"];
    if (![sharedFM fileExistsAtPath:appDataDir.path]) {
        if (![sharedFM createDirectoryAtURL:appDataDir withIntermediateDirectories:YES attributes:nil error:nil]) {
            NSLog(@"Couldn't create appDataDir");
            return;
        }
    }
    
    // 2.异步执行复制
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 3.使用init方法初始化文件管理器，以便后面可能用到代理方法。
        NSFileManager *theFM = [[NSFileManager alloc] init];
        NSError *anError;
        
        // 4.尝试复制文件
        if (![theFM copyItemAtURL:appDataDir toURL:backupDir error:&anError]) {
            // 5.如果复制失败，可能是backupDir已经存在，删除旧的backupDir文件
            if ([theFM removeItemAtURL:backupDir error:&anError]) {
                // 6.再次复制，如果失败，终止复制操作。
                if (![theFM copyItemAtURL:appDataDir toURL:backupDir error:&anError]) {
                    NSLog(@"anError:%@",anError);
                }
            }
        }
    });
}

// 一次枚举一个对象
- (void)enumerateOneFileAtATimeAtURL:(NSURL *)enumerateURL {
    NSArray *keys = [NSArray arrayWithObjects:NSURLIsDirectoryKey, NSURLLocalizedNameKey, nil];
    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtURL:enumerateURL
                                                             includingPropertiesForKeys:keys
                                                                                options:NSDirectoryEnumerationSkipsSubdirectoryDescendants | NSDirectoryEnumerationSkipsHiddenFiles
                                                                           errorHandler:^BOOL(NSURL * _Nonnull url, NSError * _Nonnull error) {
                                                                               // 1.遇到错误时输出错误，并继续递归。
                                                                               if (error) {
                                                                                   NSLog(@"[error] %@ %@",error, url);
                                                                               }
                                                                               return YES;
                                                                           }];
    for (NSURL *url in enumerator) {
        NSNumber *isDirectory = nil;
        NSError *error;
        if (![url getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:&error]) {
            NSLog(@"%@ %@",error, url);
        }
        
        if (isDirectory.boolValue) {
            //            // 2.扩展名为backup时，跳过递归。
            //            if ([url.pathExtension isEqualToString:@"backup"]) {
            //                [enumerator skipDescendants];
            //                continue;
            //            }
            
            NSString *localizedName = nil;
            if ([url getResourceValue:&localizedName forKey:NSURLLocalizedNameKey error:NULL]) {
                NSLog(@"Directory at %@",localizedName);
            }
        }
    }
}

// 一次枚举整个目录
- (void)enumerateAllAtOnceAtURL:(NSURL *)enumerateURL {
    NSError *error;
    NSArray *properties = [NSArray arrayWithObjects:NSURLLocalizedNameKey, NSURLCreationDateKey, NSURLLocalizedTypeDescriptionKey, nil];
    NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:enumerateURL
                                                      includingPropertiesForKeys:properties
                                                                         options:NSDirectoryEnumerationSkipsHiddenFiles
                                                                           error:&error];
    if (error) {
        NSLog(@"Couldn't enumerate directory. error:%@",error);
    }
    
    for (NSURL *url in contents) {
        NSDate *yesterday = [NSDate dateWithTimeIntervalSinceNow:(-24*60*60)];
        
        // 1.获取项目的文件属性，使用NSURLCreationDateKey键提取文件创建日期
        NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:url.path error:nil];
        NSDate *lastModificationDate = [attributes valueForKey:NSURLCreationDateKey];
        
        // 2.如果文件在24小时内创建 输出文件路径到控制台。
        if ([yesterday earlierDate:lastModificationDate] == yesterday) {
            NSLog(@"%@ was modified within the last 24 hours", url);
        }
        
    }
}

@end
