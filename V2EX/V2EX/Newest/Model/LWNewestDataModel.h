//
//  NewestDataModel.h
//  V2EX
//
//  Created by 吴露 on 15/11/16.
//  Copyright (c) 2015年 吴露. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MemberModel.h"
#import "NodeModel.h"
@interface LWNewestDataModel : NSObject
@property(nonatomic,assign)NSInteger memberID;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *url;
@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSString *content_rendered;
@property(nonatomic,assign)NSInteger replies;
@property(nonatomic,assign)NSInteger created;
@property(nonatomic,assign)NSInteger last_modified;
@property(nonatomic,assign)NSInteger last_touched;
@property(nonatomic,strong)MemberModel *member;
@property(nonatomic,copy)NodeModel *node;
@end
