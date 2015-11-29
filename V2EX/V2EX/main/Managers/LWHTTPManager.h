//
//  LWHTTPManager.h
//  V2EX
//
//  Created by 吴露 on 15/11/15.
//  Copyright (c) 2015年 吴露. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, LWRequestMethod) {
    JSONGET = 1,
    HTTPPOST = 2,
    HTTPGET = 3,
    HTTPGETPC = 4
};

typedef NS_ENUM (NSInteger, V2ClassilyType) {
    
    V2ClassilyTypeTech,
    V2ClassilyTypeCreative,
    V2ClassilyTypePlay,
    V2ClassilyTypeApple,
    V2ClassilyTypeJobs,
    V2ClassilyTypeDeals,
    V2ClassilyTypeCity,
    V2ClassilyTypeQna,
    V2ClassilyTypeHot,
    V2ClassilyTypeAll,
    V2ClassilyTypeR2,
    V2ClassilyTypeNodes,
    V2ClassilyTypeMembers,
    V2ClassilyTypeFav,
    
};

@interface LWHTTPManager : NSObject
+(LWHTTPManager*)shareManager;

//登录
-(NSURLSessionDataTask*)UserLogWithName:(NSString*)username
                               password:(NSString*)password
                                success:(void (^)(NSString* message))success
                                failure:(void (^)(NSError* error))failure;
//获取最新主题
-(NSURLSessionDataTask*)NewestInfoWith:(NSString*)strURL
                               success:(void(^)(NSArray *))success
                               failure:(void(^)(NSError*))failure;


//获取主题的详细信息
-(NSURLSessionDataTask*)GetTopicsWithID:(NSString*)themeID
                                success:(void(^)(NSArray *))success
                                failure:(void(^)(NSError*))failure;

//获取主题的回复
-(NSURLSessionDataTask*)GetRepliesWithID:(NSString*)Id
                                    Page:(NSInteger)page
                                PageSize:(NSInteger)page_size
                                 success:(void(^)(NSArray*))success
                                 failure:(void(^)(NSError*))failure;
//获取各个分类的数据
-(NSURLSessionTask*)GetClassilyDataWith:(V2ClassilyType)classilyType
                                success:(void(^)(id data))success
                                failure:(void(^)(NSError* error))failure;
@end
