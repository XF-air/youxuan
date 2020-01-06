//
//  YXAddTitleAddressView.h
//  youxuan
//
//  Created by 肖锋 on 2019/10/23.
//  Copyright © 2019 肖锋. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    SHP_ADDRESS_MINETYPE = 0,
    SHP_ADDRESS_OTHERTYP
}SHP_ADDRESS_TYP;

typedef enum {
    SHP_CODE_PROVINCE = 1,
    SHP_CODE_CITY,
    SHP_CODE_AREA
}SHP_CODE_TYPE;

typedef enum {
    SHP_ONE_CODE = 0,
    SHP_ALL_CODE
}SHP_TYPE;

@protocol  YXAddTitleAddressViewDelegate <NSObject>
-(void)cancelBtnClick:(NSString *)titleAddress titleID:(NSString *)titleID adcode:(NSString *)adCode city:(NSString *)city;
@end
@interface YXAddTitleAddressView : UIView
@property(nonatomic,assign)id<YXAddTitleAddressViewDelegate>delegate1;
@property(nonatomic,assign)NSInteger userID;
@property(nonatomic,assign)NSUInteger defaultHeight;
@property(nonatomic,assign)CGFloat titleScrollViewH;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,strong)UIView *addAddressView;
@property (nonatomic, assign) SHP_ADDRESS_TYP type;
@property (nonatomic, assign) SHP_CODE_TYPE typeCode;
@property (nonatomic, assign) SHP_TYPE isAllCodeType;
@property (nonatomic, strong) NSString *code;
-(UIView *)yx_initAddressView;
-(void)addAnimate;
@end
