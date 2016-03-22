
//  LWHTTPManager.m
//  V2EX
//
//  Created by 吴露 on 15/11/15.
//  Copyright (c) 2015年 吴露. All rights reserved.
//

#import "LWHTTPManager.h"
#import <AFNetworking.h>
#import "HTMLParser.h"
#import "LWNewestDataModel.h"

#define BASEURL @"http://www.v2ex.com"

@interface LWHTTPManager()
@property(nonatomic,strong)AFHTTPSessionManager *manager;

@end

@implementation LWHTTPManager
+(LWHTTPManager*)shareManager{
    static LWHTTPManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[LWHTTPManager alloc]init];
    });
    return manager;
}
-(instancetype)init{
    if (self = [super init]) {
        self.manager = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:BASEURL]];
    }
    return self;
}

-(NSURLSessionDataTask*)requestWithMethod:(LWRequestMethod)method
                                URLString:(NSString*)URLString
                                paramters:(NSDictionary*)parameters
                                  success:(void(^)(NSURLSessionDataTask *task ,id responseObject))success
                                  failure:(void(^)(NSError *error))failure{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    void (^responseHandleBlock)(NSURLSessionDataTask *task ,id responseObject) = ^(NSURLSessionDataTask *task ,id responseObject){
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        success(task,responseObject);
    };
    NSURLSessionDataTask *task = nil;
    
    if (method == 0) {
        method = JSONGET;
    }
    
    if (method == JSONGET) {
        AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
        self.manager.responseSerializer = responseSerializer;
        task = [self.manager GET:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"%@",responseObject);
            responseHandleBlock(task,responseObject);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            LWLog(@"%@",[error description]);
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            failure(error);
        }];
    }
    
    if (method == HTTPGET) {
        AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
        self.manager.responseSerializer = responseSerializer;
        task = [self.manager GET:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"%@",responseObject);
            NSString *str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"%@",str);
            responseHandleBlock(task,responseObject);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            LWLog(@"%@",[error description]);
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            failure(error);
        }];
    }
    
    if (method == HTTPPOST) {
        AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
        self.manager.responseSerializer = responseSerializer;
        task = [self.manager POST:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"%@",responseObject);
            responseHandleBlock(task, responseObject);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            failure(error);
        }];
    }
    
    if (method == HTTPGETPC) {
        AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
        self.manager.responseSerializer = responseSerializer;
//        [self.manager.requestSerializer setValue:self.userAgentPC forHTTPHeaderField:@"User-Agent"];
        task = [self.manager GET:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"%@",responseObject);
            responseHandleBlock(task, responseObject);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            failure(error);
        }];
    }
    return 0;
}

-(NSURLSessionDataTask *)NewestInfoWith:(NSString *)strURL success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure{
   return  [self requestWithMethod:HTTPGET URLString:strURL paramters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",task);
       id data = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
       success(data);
    } failure:^(NSError *error) {
        NSLog(@"%@",error.description);
    }];
}

//获取主题的详细信息
-(NSURLSessionDataTask*)GetTopicsWithID:(NSString*)themeID
                                success:(void(^)(NSArray *))success
                                failure:(void(^)(NSError*))failure
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:themeID forKey:@"id"];
    [self requestWithMethod:HTTPGET URLString:@"/api/topics/show.json" paramters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        id data = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        success(data);
    } failure:^(NSError *error) {
        NSLog(@"%@",error.description);
        failure(error);
    }];
    return nil;
}



//取主题的回复
-(NSURLSessionDataTask*)GetRepliesWithID:(NSString*)Id
                                    Page:(NSInteger)page
                                PageSize:(NSInteger)page_size
                                 success:(void(^)(NSArray *))success
                                 failure:(void(^)(NSError*))failure{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:Id forKey:@"topic_id"];
    [params setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    [params setObject:[NSNumber numberWithInteger:page_size] forKey:@"page_size"];
    return [self requestWithMethod:JSONGET URLString:@"/api/replies/show.json" paramters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        id data = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        success(data);
    } failure:^(NSError *error) {
        NSLog(@"%@",error.description);
        failure(error);
    }];
}
//获取各个分类的数据
-(NSURLSessionTask*)GetClassilyDataWith:(V2ClassilyType)classilyType
                                success:(void(^)(id data))success
                                failure:(void(^)(NSError* error))failure{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
        switch (classilyType) {
                case V2ClassilyTypeTech:
                   [ params setObject:@"tech" forKey:@"tab"];
                break;
                case V2ClassilyTypeCreative:
                    [ params setObject:@"creative" forKey:@"tab"];
                break;
                case V2ClassilyTypePlay:
                    [ params setObject:@"play" forKey:@"tab"];
                break;
                case V2ClassilyTypeApple:
                    [ params setObject:@"apple" forKey:@"tab"];
                break;
                case V2ClassilyTypeJobs:
                    [ params setObject:@"jobs" forKey:@"tab"];
                break;
                case V2ClassilyTypeDeals:
                    [ params setObject:@"deals" forKey:@"tab"];
                break;
                case V2ClassilyTypeCity:
                    [ params setObject:@"city" forKey:@"tab"];
                break;
                case V2ClassilyTypeQna:
                    [ params setObject:@"qna" forKey:@"tab"];
                break;
                case V2ClassilyTypeHot:
                    [ params setObject:@"hot" forKey:@"tab"];
                break;
                case V2ClassilyTypeAll:
                    [ params setObject:@"hot" forKey:@"tab"];
                break;
            case V2ClassilyTypeR2:
                    [ params setObject:@"r2" forKey:@"tab"];
                break;
        default:
            break;
    }
    WeakSelf;
    return [self requestWithMethod:HTTPGET URLString:@"" paramters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        StrongSelf;
        NSMutableArray *array = [strongSelf getTopicListFromResponseObject:responseObject];
        success(array);
    } failure:^(NSError *error) {
        failure(error);
    }];
    return nil;
}

-(NSMutableArray *)getTopicListFromResponseObject:(id)responseObject {
    
    NSMutableArray *topicArray = [[NSMutableArray alloc] init];
    
    @autoreleasepool {
        
        
        NSString *htmlString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        NSError *error = nil;
        HTMLParser *parser = [[HTMLParser alloc] initWithString:htmlString error:&error];
        
        if (error) {
            NSLog(@"Error: %@", error);
        }
        
        HTMLNode *bodyNode = [parser body];
        
        NSArray *cellNodes = [bodyNode findChildTags:@"div"];
        
        for (HTMLNode *cellNode in cellNodes) {
            if ([[cellNode getAttributeNamed:@"class"] isEqualToString:@"cell item"]) {
                
                //                NSLog(@"%@", cellNode.rawContents);
                
                LWNewestDataModel *model = [[LWNewestDataModel alloc] init];
//                model.member = [[LWNewestDataModel alloc] init];
//                model.node = [[LWNewestDataModel alloc] init];
                
                NSArray *tdNodes = [cellNode findChildTags:@"td"];
                
                NSInteger index = 0;
                for (HTMLNode *tdNode in tdNodes) {
                    
                    //                    NSLog(@"td:\n%@", tdNode.rawContents);
                    NSString *content = tdNode.rawContents;
                    
                    //                    if (index == 0) {
                    if ([content rangeOfString:@"class=\"avatar\""].location != NSNotFound) {
                        
                        HTMLNode *userIdNode = [tdNode findChildTag:@"a"];
                        if (userIdNode) {
                            NSString *idUrlString = [userIdNode getAttributeNamed:@"href"];
                            model.member.username = [[idUrlString componentsSeparatedByString:@"/"] lastObject];
                        }
                        
                        HTMLNode *avatarNode = [tdNode findChildTag:@"img"];
                        if (avatarNode) {
                            NSString *avatarString = [avatarNode getAttributeNamed:@"src"];
                            if ([avatarString hasPrefix:@"//"]) {
                                avatarString = [@"http:" stringByAppendingString:avatarString];
                            }
                            model.member.avatar_normal = avatarString;
                        }
                    }
                    
                    //                    if (index == 2) {
                    //                        NSLog(@"td:\n%@", tdNode.rawContents);
                    if ([content rangeOfString:@"class=\"item_title\""].location != NSNotFound) {
                        
                        NSArray *aNodes = [tdNode findChildTags:@"a"];
                        
                        for (HTMLNode *aNode in aNodes) {
                            if ([[aNode getAttributeNamed:@"class"] isEqualToString:@"node"]) {
                                NSString *nodeUrlString = [aNode getAttributeNamed:@"href"];
                                model.node.name = [[nodeUrlString componentsSeparatedByString:@"/"] lastObject];
                                model.node.title = aNode.allContents;
                                
                            } else {
                                if ([aNode.rawContents rangeOfString:@"reply"].location != NSNotFound) {
                                    model.title = aNode.allContents;
                                    
                                    NSString *topicIdString = [aNode getAttributeNamed:@"href"];
                                    NSArray *subArray = [topicIdString componentsSeparatedByString:@"#"];
                                    model.memberID = [[(NSString *)subArray.firstObject stringByReplacingOccurrencesOfString:@"/t/" withString:@""] integerValue];
                                    model.replies = [[(NSString *)subArray.lastObject stringByReplacingOccurrencesOfString:@"reply" withString:@""] integerValue];
                                    
                                    
                                }
                            }
                            
                    }
                       
                        NSArray *spanNodes = [tdNode findChildTags:@"span"];
                        for (HTMLNode *spanNode in spanNodes) {
                            if ([spanNode.rawContents rangeOfString:@"href"].location == NSNotFound) {
                                model.created = [spanNode.allContents integerValue];
                            }
                            
                            if ([spanNode.rawContents rangeOfString:@"最后回复"].location != NSNotFound || [spanNode.rawContents rangeOfString:@"前"].location != NSNotFound) {
                                
                                NSString *contentString = spanNode.allContents;
                                NSArray *components = [contentString componentsSeparatedByString:@"  •  "];
                                NSString *dateString;
                                
                                if (components.count >= 2) {
                                    dateString = components[0];
                                }
                                else{
                                    dateString = @"刚刚";
                                }
                                model.createTime = dateString;
                                
//                                NSArray *stringArray = [dateString componentsSeparatedByString:@" "];
//                                if (stringArray.count > 1) {
//                                    NSString *unitString = @"";
//                                    NSString *subString = [(NSString *)stringArray[1] substringToIndex:1];
//                                    if ([subString isEqualToString:@"分"]) {
//                                        unitString = @"分钟前";
//                                    }
//                                    if ([subString isEqualToString:@"小"]) {
//                                        unitString = @"小时前";
//                                    }
//                                    if ([subString isEqualToString:@"天"]) {
//                                        unitString = @"天前";
//                                    }
//                                    //                                    unitString = stringArray[1];
//                                    dateString = [NSString stringWithFormat:@"%@%@", stringArray[0], unitString];
//                                } else {
//                                    //                                    dateString = @"just now";
//                                    dateString = @"刚刚";
//                                }
//                                model.created = [dateString integerValue];
                            }
                        }
                        
                    }
                    
                    
                    index ++;
                }
                
//                model.state = [[V2TopicStateManager manager] getTopicStateWithTopicModel:model];
//                model.cellHeight = [V2TopicListCell heightWithTopicModel:model];
                
                [topicArray addObject:model];
            }
        }
        
    }
    
    
    return topicArray;
    
}

-(NSURLSessionDataTask *)UserLogWithName:(NSString *)username password:(NSString *)password success:(void (^)(NSString *))success failure:(void (^)(NSError *))failure{
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
    [self requestOnceWithURLString:@"/signin" success:^(NSString *onceString) {
        NSDictionary *parameters = [[NSDictionary alloc]initWithObjectsAndKeys:onceString,@"once",@"/",@"next",password,@"p",username,@"u", nil];
        [self.manager.requestSerializer setValue:@"http://v2ex.com/signin" forHTTPHeaderField:@"Referer"];
        [self requestWithMethod:HTTPPOST URLString:@"/signin" paramters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
            NSString *htmlString = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
            if ([htmlString rangeOfString:@"/notifications"].location != NSNotFound) {
                success(username);
            }
            else{
                NSError *error = [[NSError alloc]initWithDomain:self.manager.baseURL.absoluteString code:1 userInfo:nil];
                failure(error);
            }
        } failure:^(NSError *error) {
            
            failure(error);
        }];
    } failure:^(NSError *error) {
        failure(error);
    }];
    return nil;
}

-(NSURLSessionDataTask *)requestOnceWithURLString:(NSString*)urlString success:(void (^)(NSString* onceString))success failure:(void (^)(NSError *error))failure{
    return [self requestWithMethod:HTTPGET URLString:urlString paramters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *onceString = [self getOnceStringFromHtmlResponseObject:responseObject];
        if (onceString) {
            success(onceString);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
}

//解析html
-(NSString*)getOnceStringFromHtmlResponseObject:(id)responseObject{
    __block NSString *onceString;
    @autoreleasepool {
        NSString *htmlString = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSError *error = nil;
        HTMLParser *parser = [[HTMLParser alloc]initWithString:htmlString error:&error];
        if (error) {
            LWLog(@"%@",error.description);
        }
        HTMLNode *bodyNode = [parser body];
        
        NSArray *inputNodes = [bodyNode findChildTags:@"input"];
        [inputNodes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            HTMLNode *aNode = obj;
            if ([[aNode getAttributeNamed:@"name"] isEqualToString:@"once"]) {
                onceString = [aNode getAttributeNamed:@"value"];
            }
        }];
    }
    return onceString;
}
@end
