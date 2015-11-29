//
//  NodeModel.m
//  V2EX
//
//  Created by 吴露 on 15/11/16.
//  Copyright (c) 2015年 吴露. All rights reserved.
//

#import "NodeModel.h"

@implementation NodeModel
+(NSDictionary*)modelCustomPropertyMapper{
    return @{@"memberID":@"id"};
}
-(id)copyWithZone:(NSZone*)zone{
    return [self yy_modelCopy];
}
@end
