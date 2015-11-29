//
//  MemberModel.h
//  V2EX
//
//  Created by 吴露 on 15/11/16.
//  Copyright (c) 2015年 吴露. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MemberModel : NSObject
@property(nonatomic,copy)NSString *username;
@property(nonatomic,assign)int memberId;
@property(nonatomic,copy)NSString *avatar_mini;
@property(nonatomic,copy)NSString *avatar_normal;
@property(nonatomic,copy)NSString *avatar_large;
@end
