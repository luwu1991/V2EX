//
//  ThemeReplyCell.m
//  V2EX
//
//  Created by 吴露 on 15/11/19.
//  Copyright (c) 2015年 吴露. All rights reserved.
//

#import "ThemeReplyCell.h"

@implementation ThemeReplyCell

- (void)awakeFromNib {
    
    [self.authorLabel setTextColor:[UIColor colorWithRed:195/255.0 green:195/255.0 blue:195/255.0 alpha:1.0f]];
    [self.dateLabel setTextColor:[UIColor colorWithRed:195/255.0 green:195/255.0 blue:195/255.0 alpha:1.0f]];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
