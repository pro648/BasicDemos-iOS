//
//  ViewController.m
//  KeyedArchiver
//
//  Created by ad on 27/07/2017.
//
//  详细介绍：https://github.com/pro648/tips/wiki/%E6%95%B0%E6%8D%AE%E5%AD%98%E5%82%A8%E4%B9%8B%E5%BD%92%E6%A1%A3%E8%A7%A3%E6%A1%A3-NSKeyedArchiver-NSKeyedUnarchiver

#import "ViewController.h"
#import "Person.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameArchiver;
@property (weak, nonatomic) IBOutlet UITextField *ageArchiver;
@property (weak, nonatomic) IBOutlet UITextField *nameUnarchiver;
@property (weak, nonatomic) IBOutlet UITextField *ageUnarchiver;
@property (strong, nonatomic) NSString *documentsPath;
@property (strong, nonatomic) Person *person;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.person = [[Person alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [self archiver:nil];
        NSLog(@"archiver");
    }];    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)documentsPath {
    if (!_documentsPath) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
        if (paths.count > 0) {
            _documentsPath = paths.firstObject;
            
            //  如果目录不存在，则创建该目录。
            if (! [[NSFileManager defaultManager] fileExistsAtPath:_documentsPath]) {
                NSError *error;
                // 创建该目录
                if(! [[NSFileManager defaultManager] createDirectoryAtPath:_documentsPath withIntermediateDirectories:YES attributes:nil error:&error])
                {
                    NSLog(@"Failed to create directory. error: %@",error);
                }
            }
        }
    }
    return _documentsPath;
}

- (IBAction)archiver:(UIButton *)sender {
    /*
    // A 使用archiveRootObject: toFile: 方法归档。
    // 1.修改当前目录为self.documentsPath。
    NSFileManager *sharedFM = [NSFileManager defaultManager];
    [sharedFM changeCurrentDirectoryPath:self.documentsPath];

    // 2.归档。
    if (![NSKeyedArchiver archiveRootObject:self.nameArchiver.text toFile:@"nameArchiver"]) {
        NSLog(@"Failed to archive nameArchiver");
    }
    if (![NSKeyedArchiver archiveRootObject:self.ageArchiver.text toFile:@"ageArchiver"]) {
        NSLog(@"Failed to archive ageArchiver");
    }
    */
    
    // B 使用initForWritingWithData: 归档。
    // 1.把当前文本框内文本传送给person。
    [self.person setName:self.nameArchiver.text age:[self.ageArchiver.text integerValue]];
    
    // 2.使用initFoWritingWithData: 方法归档内容至mutableData。
    NSMutableData *mutableData = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:mutableData];
    [archiver encodeObject:self.person forKey:@"person"];
    [archiver finishEncoding];
    
    // 3.把归档写入Library/Application Support/Data目录。
    NSString *filePath = [self.documentsPath stringByAppendingPathComponent:@"Data"];
    if (![mutableData writeToFile:filePath atomically:YES]) {
        NSLog(@"Failed to write file to filePath");
    }
}

- (IBAction)unarchiver:(UIButton *)sender {
    /*
    // A 使用unarchiveObjectWithFile: 读取归档。
    // 1.获取归档路径。
    NSString *nameArchiver = [self.documentsPath stringByAppendingPathComponent:@"nameArchiver"];
    NSString *ageArchiver = [self.documentsPath stringByAppendingPathComponent:@"ageArchiver"];
    
    // 2.读取归档，并将其赋值给对应文本框。
    self.nameUnarchiver.text = [NSKeyedUnarchiver unarchiveObjectWithFile:nameArchiver];
    self.ageUnarchiver.text = [NSKeyedUnarchiver unarchiveObjectWithFile:ageArchiver];
    */

    // B 使用initForReadingWithData: 读取归档。
    // 1.从Library/Application Support/Data目录获取归档文件。
    NSString *filePath = [self.documentsPath stringByAppendingPathComponent:@"Data"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    // 2.使用initForReadingWithData: 读取归档。
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    self.person = [unarchiver decodeObjectForKey:@"person"];
    [unarchiver finishDecoding];
    
    // 3.把读取到的内容显示到对应文本框。
    self.nameUnarchiver.text = self.person.name;
    self.ageUnarchiver.text = [@(self.person.age) stringValue];
}

@end
