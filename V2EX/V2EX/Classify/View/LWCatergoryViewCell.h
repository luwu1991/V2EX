//
//  LWCatergoryViewCell.h
//  V2EX
//
//  Created by wulu on 16/3/16.
//  Copyright © 2016年 吴露. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LWCatergoryViewCellModel;

@interface LWCatergoryViewCell : UICollectionViewCell
@property (strong, nonatomic) NSString  *title;
@property (strong, nonatomic) UILabel  *titleLabel;
@property (strong, nonatomic) LWCatergoryViewCellModel  *data;
-(void)updateCellWithIndexPath:(NSIndexPath*)indexPath;
-(void)reCoverCellWithIndexPath:(NSIndexPath*)indexPath;
@end
