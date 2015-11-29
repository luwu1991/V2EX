//
//  NodeModel.h
//  V2EX
//
//  Created by 吴露 on 15/11/16.
//  Copyright (c) 2015年 吴露. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYModel.h"
@interface NodeModel : NSObject
@property(nonatomic,assign)NSInteger memberID;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *title_alternative;
@property(nonatomic,copy)NSString *url;
@property(nonatomic,assign)NSInteger topics;
@property(nonatomic,copy)NSString *avatar_mini;
@property(nonatomic,copy)NSString *avatar_normal;
@property(nonatomic,copy)NSString *avatar_large;
@end
