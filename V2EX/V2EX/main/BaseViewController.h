//
//  BaseViewController.h
//  V2EX
//
//  Created by 吴露 on 15/9/26.
//  Copyright (c) 2015年 吴露. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIview+FrameMethods.h"
#import "MBProgressHUD+WJTools.h"
#import "NSString+URLEncoding.h"
#import "AFNetworkTool.h"
@interface BaseViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *listTableView;
@end
