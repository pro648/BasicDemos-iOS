//
//  CollectionViewCell.m
//  CollectionView
//
//  Created by ad on 12/12/2017.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 1.初始化imageView、label。
        CGFloat cellWidth = self.bounds.size.width;
        CGFloat cellHeight = self.bounds.size.height;
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cellWidth, cellHeight * 4/5)];
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, cellHeight * 4/5, cellWidth, cellHeight * 1/5)];
        _label.textAlignment = NSTextAlignmentCenter;
        
        // 2.添加imageView、label到cell。
        [self.contentView addSubview:_imageView];
        [self.contentView addSubview:_label];
    }
    return self;
}

@end
