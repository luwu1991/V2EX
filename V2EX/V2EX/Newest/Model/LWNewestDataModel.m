//
//  NewestDataModel.m
//  V2EX
//
//  Created by 吴露 on 15/11/16.
//  Copyright (c) 2015年 吴露. All rights reserved.
//

#import "LWNewestDataModel.h"

@implementation LWNewestDataModel
-(instancetype)init{
    if (self=[super init]) {
        self.member = [[MemberModel alloc]init];
        self.node = [[NodeModel alloc]init];
    }
    return self;
}
+(NSDictionary*)modelCustomPropertyMapper{
    return @{@"memberID":@"id"};
}

-(NSString *)description{
    [super description];
    NSLog(@"memberID:%ld",self.memberID);
    NSLog(@"title:%@",self.title);
    NSLog(@"url:%@",self.url);
    NSLog(@"content:%@",self.content);
    NSLog(@"content_rendered:%@",self.content_rendered);
    NSLog(@"replies:%ld",self.replies);
    NSLog(@"created:%ld",self.created);
    NSLog(@"last_touched:%ld",self.last_touched);
    NSLog(@"last_modified:%ld",self.last_modified);
    return [super description];
}
@end
