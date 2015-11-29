//
//  NSString+URLEncoding.m
//  同步GET
//
//  Created by 张学飞 on 15/6/2.
//  Copyright (c) 2015年 jiachengdongman. All rights reserved.
//

#import "NSString+URLEncoding.h"

@implementation NSString (URLEncoding)


//将字符串转化为URL
-(NSString*)URLEncodedString
{
    NSString * result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes
                                                      (kCFAllocatorDefault,
                                                       (CFStringRef)self,
                                                       NULL,
                                                       CFSTR("+$,#[] "),
                                                       kCFStringEncodingUTF8));
    return result;
}

//将URL转化为字符串
-(NSString *)URLDecodedString
{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, (CFStringRef)self, CFSTR(" "), kCFStringEncodingUTF8));
    
    return result;
}

@end
