//
//  NewestDateilViewController.h
//  V2EX
//
//  Created by 吴露 on 15/11/19.
//  Copyright (c) 2015年 吴露. All rights reserved.
//

#import "BaseViewController.h"
#import "LWNewestDataModel.h"
@interface NewestDateilViewController : BaseViewController
@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSString *author;
@property(nonatomic,copy)NSString *date;
@property(nonatomic,copy)NSString *imageURL;
@property(nonatomic,copy)NSString *themeID;
@property(nonatomic,strong)LWNewestDataModel *theme;
@end
