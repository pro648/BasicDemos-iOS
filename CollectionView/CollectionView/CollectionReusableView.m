//
//  CollectionReusableView.m
//  CollectionView
//
//  Created by ad on 08/12/2017.
//

#import "CollectionReusableView.h"

@implementation CollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 初始化label，设置文字颜色，最后添加label到重用视图。
        _label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.bounds.size.width-40, self.bounds.size.height)];
        _label.textColor = [UIColor blackColor];
        [self addSubview:_label];
    }
    return self;
}

@end
