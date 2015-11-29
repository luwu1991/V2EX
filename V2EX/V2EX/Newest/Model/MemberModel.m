//
//  MemberModel.m
//  V2EX
//
//  Created by 吴露 on 15/11/16.
//  Copyright (c) 2015年 吴露. All rights reserved.
//

#import "MemberModel.h"

@implementation MemberModel
+(NSDictionary*)modelCustomPropertyMapper{
    return @{@"memberId":@"id"};
}
@end
