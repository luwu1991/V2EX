//
//  LWCatergoryViewCell.m
//  V2EX
//
//  Created by wulu on 16/3/16.
//  Copyright © 2016年 吴露. All rights reserved.
//

#import "LWCatergoryViewCell.h"
#import "LWCatergoryViewCellModel.h"

@interface LWCatergoryViewCell()

@end

@implementation LWCatergoryViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self lW_initializeUI];
    }
    return self;
}


-(void)lW_initializeUI{
    self.backgroundColor = [UIColor clearColor];
    UILabel *titleLabel = [UILabel new];
    titleLabel.textAlignment = 1;
    titleLabel.frame = self.bounds;
    titleLabel.font = [UIFont systemFontOfSize:17];
    self.titleLabel = titleLabel;
    [self.contentView addSubview:titleLabel];
}

-(void)setData:(LWCatergoryViewCellModel *)data{
    _data = data;
    self.title = data.title;
}

-(void)setTitle:(NSString *)title{
    self.titleLabel.text = title;
}

-(void)updateCellWithIndexPath:(NSIndexPath*)indexPath{
    if (indexPath.row == self.data.index) {
        [self.titleLabel setTextColor:[UIColor redColor]];
    }
    else{
        [self.titleLabel setTextColor:[UIColor blackColor]];
    }
}

-(void)reCoverCell{
    [self.titleLabel setTextColor:[UIColor blackColor]];
}

@end
