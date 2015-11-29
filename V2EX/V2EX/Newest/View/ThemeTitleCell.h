//
//  ThemeTitleCell.h
//  V2EX
//
//  Created by 吴露 on 15/11/19.
//  Copyright (c) 2015年 吴露. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThemeTitleCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *printImage;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *replyLabel;

@end
