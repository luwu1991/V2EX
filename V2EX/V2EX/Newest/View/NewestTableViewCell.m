//
//  NewestTableViewCell.m
//  V2EX
//
//  Created by 吴露 on 15/11/18.
//  Copyright (c) 2015年 吴露. All rights reserved.
//

#import "NewestTableViewCell.h"

@implementation NewestTableViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"NestestTableViewCell" owner:self options:nil];
        if (array.count < 1) {
            return 0;
        }
        self = [array lastObject];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
    self.classifyLabel.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0f];
    self.dateLabel.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0f];
    [self.titleLabel setTextColor:[UIColor colorWithRed:110/255.0 green:120/255.0 blue:139/255.0 alpha:1.0f]];
    self.printImage.layer.cornerRadius = 5;
    self.printImage.layer.masksToBounds = YES;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
