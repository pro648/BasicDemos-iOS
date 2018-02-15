//
//  CollectionViewController.m
//  GrandCentralDispatch
//
//  Created by ad on 07/02/2018.
//

#import "CollectionViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <ELCImagePickerController.h>
#import "DetailViewController.h"
#import "PhotoManager.h"

@interface CollectionViewController () <ELCImagePickerControllerDelegate, UICollectionViewDataSource, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) ALAssetsLibrary *library;
@property (assign, nonatomic) CGSize headerSize;

@end

static const NSUInteger kCellImageViewTag = 3;
static const CGFloat kBackgroundImageOpacity = 0.1f;

@implementation CollectionViewController

static NSString * const reuseIdentifier = @"CellIdentifier";
extern NSString * const kPhotoManagerContentUpdateNotification;
extern NSString * const kPhotoManagerAddedContentNotification;

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.library = [[ALAssetsLibrary alloc] init];
    self.collectionView.delegate = self;
    
    // Background image setup.
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
    backgroundImageView.alpha = kBackgroundImageOpacity;
    backgroundImageView.contentMode = UIViewContentModeCenter;
    self.collectionView.backgroundView = backgroundImageView;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(contentChangedNotification:)
                                                 name:kPhotoManagerContentUpdateNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(contentChangedNotification:)
                                                 name:kPhotoManagerAddedContentNotification
                                               object:NULL];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self showOrHideNavPrompt];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger count = [[[PhotoManager sharedManager] photos] count];
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:kCellImageViewTag];
    NSArray *photoAssets = [[PhotoManager sharedManager] photos];
    Photo *photo = photoAssets[indexPath.row];
    
    switch (photo.status) {
        case PhotoStatusGoodToGo:
            imageView.image = [photo thumbnail];
            break;
            
        case PhotoStatusDownloading:
            imageView.image = [UIImage imageNamed:@"photoDownloading"];
            break;
            
        case PhotoStatusFailed:
            imageView.image = [UIImage imageNamed:@"photoDownloadError"];
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"sectionHeader" forIndexPath:indexPath];
    }
    return reusableView;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return self.headerSize;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowDetail"]) {
        DetailViewController *detailVC = segue.destinationViewController;
        if (sender != nil) {
            UICollectionViewCell *cell = (UICollectionViewCell *)sender;
            NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
            NSArray *photos = [[PhotoManager sharedManager] photos];
            Photo *photo = photos[indexPath.row];
            
            // 点击cell时，如果图片存在，在DetailVC界面显示。如果不存在、正在下载，使用alert提醒用户。
            [self selectPhoto:photo destinationViewController:detailVC];
        }
    }
}

- (void)selectPhoto:(Photo *)photo destinationViewController:(DetailViewController *)detailVC {
    switch (photo.status) {
        case PhotoStatusGoodToGo:{
            // 图片存在时，在DetailVC中显示。
            UIImage *image = [photo image];
            detailVC.image = image;
            break;
        }
            
        case PhotoStatusDownloading:{
            // 正在下载图片时，使用alert提醒用户。
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Downloading"
                                                                                     message:@"The image is currently downloading"
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                               style:UIAlertActionStyleDefault
                                                             handler:nil];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
            break;
        }
            
        case PhotoStatusFailed:{
            // 图片下载失败时，使用alert提醒用户。
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Image Failed"
                                                                                     message:@"The image failed to be created"
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                               style:UIAlertActionStyleDefault
                                                             handler:nil];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
            
        default:
            break;
    }
}

#pragma mark - elcImagePickerControllerDelegate

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info {
    for (NSDictionary *dict in info) {
        [self.library assetForURL:dict[UIImagePickerControllerReferenceURL] resultBlock:^(ALAsset *asset) {
            Photo *photo = [[Photo alloc] initWithAsset:asset];
            [[PhotoManager sharedManager] addPhoto:photo];
        } failureBlock:^(NSError *error) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Permission Denied"
                                                                                     message:@"To access your photos, Please change the permissions in Settings"
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                               style:UIAlertActionStyleDefault
                                                             handler:nil];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }];
    }
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker {
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)addPhotoAssets:(UIBarButtonItem *)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Get Photos From:"
                                                                             message:NULL
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *photoLibraryAction = [UIAlertAction actionWithTitle:@"Photo Library"
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * _Nonnull action) {
           // TODO: photo library.
           ELCImagePickerController *imagePickerController = [[ELCImagePickerController alloc] init];
           imagePickerController.imagePickerDelegate = self;
           UIPopoverPresentationController *popover = alertController.popoverPresentationController;
           if (popover) {
               popover.barButtonItem = self.navigationItem.rightBarButtonItem;
           }
           [self presentViewController:imagePickerController animated:YES completion:nil];
                                                               }];
    UIAlertAction *internetAction = [UIAlertAction actionWithTitle:@"Internet"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * _Nonnull action) {
                                                               // TODO: internet.
                                                               [self downloadImageAssets];
                                                           }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    [alertController addAction:photoLibraryAction];
    [alertController addAction:internetAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Private Methods

- (void)contentChangedNotification:(NSNotification *)notification {
    [self.collectionView reloadData];
    [self showOrHideNavPrompt];
}

- (void)showOrHideNavPrompt {
    // TODO: Implement me.
}

- (void)downloadImageAssets {
    [[PhotoManager sharedManager] downloadPhotosWithCompletionBlock:^(NSError *error) {
        // This completion block currently executes at the wrong time.
        NSString *message = error ? [error localizedDescription] : @"The images have finished downloading";
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Download Complete"
                                                                                 message:message
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }];
}

@end
