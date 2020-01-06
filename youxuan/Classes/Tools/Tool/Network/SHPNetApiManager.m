//
//  SHPNetApiManager.m
//  appOfShrimp
//
//  Created by 肖锋 on 2019/7/10.
//  Copyright © 2019年 technologyToZhuoKai. All rights reserved.
//

#import "SHPNetApiManager.h"

@implementation SHPNetApiManager

+ (instancetype)sharedManager
{
    static SHPNetApiManager *shared_manager = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        shared_manager = [[self alloc] init];
    });
    return shared_manager;
}


- (void)shp_requestCheckAreaInfoWithParams:(NSDictionary *)dictParams block:(void (^)(id data, NSError *error))block
{
    [[XFZKNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"/area/info" withParams:dictParams withMethodType:Get andBlock:^(id  _Nonnull data, NSError * _Nonnull error) {
        if (data) {
            block(data, nil);
        }else{
            block(nil, error);
        }
    }];
}

- (void)shp_requestCheckAreaInfoAllWithParams:(NSDictionary *)dictParams block:(void (^)(id data, NSError *error))block
{
    [[XFZKNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"/area/infoAll" withParams:dictParams withMethodType:Get andBlock:^(id  _Nonnull data, NSError * _Nonnull error) {
        if (data) {
            block(data, nil);
        }else{
            block(nil, error);
        }
    }];
}

@end
