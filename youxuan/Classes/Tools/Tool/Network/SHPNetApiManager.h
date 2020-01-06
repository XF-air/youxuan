//
//  SHPNetApiManager.h
//  appOfShrimp
//
//  Created by 肖锋 on 2019/7/10.
//  Copyright © 2019年 technologyToZhuoKai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XFZKNetAPIClient.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    SHP_NETMINE_TYPE = 0,
    SHP_NETUSER_TYPE
}SHP_NETORDER_TYPE;;

@interface SHPNetApiManager : NSObject

+ (instancetype)sharedManager;


#pragma mark - 查询开通的城市
- (void)shp_requestCheckAreaInfoWithParams:(NSDictionary *)dictParams block:(void (^)(id data, NSError *error))block;

#pragma mark - 查询全部的城市
- (void)shp_requestCheckAreaInfoAllWithParams:(NSDictionary *)dictParams block:(void (^)(id data, NSError *error))block;

@end

NS_ASSUME_NONNULL_END
