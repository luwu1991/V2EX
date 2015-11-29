//
//  RepliesModel.h
//  V2EX
//
//  Created by 吴露 on 15/11/19.
//  Copyright (c) 2015年 吴露. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MemberModel.h"
@interface RepliesModel : NSObject
@property(nonatomic,assign)NSInteger id;
@property(nonatomic,assign)NSInteger thanks;
@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSString *content_rendered;
@property(nonatomic,assign)NSInteger created;
@property(nonatomic,assign)NSInteger last_modified;
@property(nonatomic,strong) MemberModel*member;
@end
