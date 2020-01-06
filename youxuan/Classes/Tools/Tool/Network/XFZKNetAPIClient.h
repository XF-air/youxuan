//
//  XFZKNetAPIClient.h
//  XFZKAFNetworking
//
//  Created by 肖锋 on 2019/5/31.
//  Copyright © 2019年 xiaoFeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

typedef enum {
    Get = 0
} NetworkMethod;


NS_ASSUME_NONNULL_BEGIN

@interface XFZKNetAPIClient : AFHTTPSessionManager


/**
 网络请求的单例

 @return 返回单例
 */
+ (instancetype)sharedJsonClient;



/**
 changeUrl

 @return 返回
 */
+ (id)changeJsonClient;


/**
总的请求方式

 @param aPath 路径
 @param params 参数
 @param method 请求类型
 @param block 结果回调
 */
- (void)requestJsonDataWithPath:(NSString *)aPath
                     withParams:(nullable NSDictionary *)params
                 withMethodType:(NetworkMethod)method
                       andBlock:(void (^)(id data, NSError *error))block;



@end

NS_ASSUME_NONNULL_END
