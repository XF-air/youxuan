//
//  XFZKNetAPIClient.m
//  XFZKAFNetworking
//
//  Created by 肖锋 on 2019/5/31.
//  Copyright © 2019年 xiaoFeng. All rights reserved.
//

#define kNetworkMethodName @[@"Get"]

//#define YX_kRelease = 0
//#define YX_BaseUrl (YX_kRelease == 0 ? @"https://shrimp-usersite.cs.xundatong.net" : @"http://shrimp-usersite.cs.niudiapp.com")

#import "XFZKNetAPIClient.h"

@implementation XFZKNetAPIClient


static XFZKNetAPIClient *_sharedClient = nil;
static dispatch_once_t onceToken;

+ (instancetype)sharedJsonClient
{
    dispatch_once(&onceToken, ^{
        _sharedClient = [[XFZKNetAPIClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://shrimp-usersite.cs.xundatong.net"]];
    });
    return _sharedClient;
}

+ (id)changeJsonClient{
    _sharedClient = [[XFZKNetAPIClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://shrimp-usersite.cs.xundatong.net"]];
    return _sharedClient;
}

- (instancetype)initWithBaseURL:(NSURL *)url
{
    if (self = [super initWithBaseURL:url]) {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
        self.securityPolicy.allowInvalidCertificates = YES;
        self.securityPolicy.validatesDomainName = NO;
    }
    return self;
}


- (void)requestJsonDataWithPath:(NSString *)aPath
                     withParams:(nullable NSDictionary *)params
                 withMethodType:(NetworkMethod)method
                       andBlock:(void (^)(id data, NSError *error))block{
    
    [self p_xfZkRequestJsonDataWithPath:aPath withParams:params withMethodType:method autoShowError:YES andBlock:block];
}

- (void)p_xfZkRequestJsonDataWithPath:(NSString *)aPath
                           withParams:(NSDictionary*)params
                       withMethodType:(NetworkMethod)method
                        autoShowError:(BOOL)autoShowError
                             andBlock:(void (^)(id data, NSError *error))block{
    if (!aPath || aPath.length <= 0) {
        return;
    }
    [self.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"YX_LOGIN_TOKEN"] forHTTPHeaderField:@"Token"];
    aPath = [aPath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    switch (method) {
        case Get:{
            [self GET:aPath parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                block(responseObject, nil);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                block(nil, error);
            }];
            break;}
        default:
            break;
    }
}



@end
