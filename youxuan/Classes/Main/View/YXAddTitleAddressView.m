//
//  YXAddTitleAddressView.m
//  youxuan
//
//  Created by 肖锋 on 2019/10/23.
//  Copyright © 2019 肖锋. All rights reserved.
//

#import "YXAddTitleAddressView.h"
#import "SHPNetApiManager.h"
#import "YXAreaMode.h"
#import <MJExtension.h>

//设备物理尺寸
#define screen_width [UIScreen mainScreen].bounds.size.width
#define screen_height [UIScreen mainScreen].bounds.size.height
#define SHP_COLOR_alpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]
#define SHP_kIs_iphone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define SHP_kIs_iPhoneX screen_width >=375.0f && screen_height >=812.0f && SHP_kIs_iphone
#define SHP_kNavBarAndStatusBarHeight (CGFloat)(SHP_kIs_iPhoneX?(88.0):(64.0))
#define SHP_MediumSysFont(f)  [UIFont fontWithName:@"PingFang-SC-Medium" size:f]
#define SHP_RegularSysFont(f)  [UIFont fontWithName:@"PingFang-SC-Regular" size:f]

@interface YXAddTitleAddressView ()<UIScrollViewDelegate,UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UIScrollView *titleScrollView;
@property(nonatomic,strong)UIScrollView *contentScrollView;
@property(nonatomic,strong)UIButton *radioBtn;
@property(nonatomic,strong)NSMutableArray *titleBtns;
@property(nonatomic,strong)NSMutableArray *titleMarr;
@property(nonatomic,strong)NSMutableArray *tableViewMarr;
@property(nonatomic,strong)UILabel *lineLabel;
@property(nonatomic,strong)NSMutableArray *titleIDMarr;
@property(nonatomic,assign)BOOL isInitalize;
@property(nonatomic,assign)BOOL isclick; //判断是滚动还是点击
@property(nonatomic,strong)NSMutableArray *provinceMarr;//省
@property(nonatomic,strong)NSMutableArray *cityMarr;//市
@property(nonatomic,strong)NSMutableArray *countyMarr;//县
@property(nonatomic,strong)NSMutableArray *townMarr;//乡
@property(nonatomic,strong)NSArray *resultArr;//本地数组

@end
@implementation YXAddTitleAddressView
-(NSMutableArray *)titleBtns
{
    if (_titleBtns == nil) {
        _titleBtns = [[NSMutableArray alloc]init];
    }
    return _titleBtns;
}
-(NSMutableArray *)titleMarr
{
    if (_titleMarr == nil) {
        _titleMarr = [[NSMutableArray alloc]init];
    }
    return _titleMarr;
}
-(NSMutableArray *)tableViewMarr
{
    if (_tableViewMarr == nil) {
        _tableViewMarr = [[NSMutableArray alloc]init];
    }
    return _tableViewMarr;
}
-(NSMutableArray *)titleIDMarr
{
    if (_titleIDMarr == nil) {
        _titleIDMarr = [[NSMutableArray alloc]init];
    }
    return _titleIDMarr;
}
-(NSMutableArray *)provinceMarr
{
    if (_provinceMarr == nil) {
        _provinceMarr = [[NSMutableArray alloc]init];
    }
    return _provinceMarr;
}
-(NSMutableArray *)cityMarr
{
    if (_cityMarr == nil) {
        _cityMarr = [[NSMutableArray alloc]init];
    }
    return _cityMarr;
}
-(NSMutableArray *)countyMarr
{
    if (_countyMarr == nil) {
        _countyMarr = [[NSMutableArray alloc]init];
    }
    return _countyMarr;
}
-(NSMutableArray *)townMarr
{
    if (_townMarr == nil) {
        _townMarr = [[NSMutableArray alloc]init];
    }
    return _townMarr;
}
- (UIView *)yx_initAddressView{
    self.frame = CGRectMake(0, 0, screen_width, screen_height - SHP_kNavBarAndStatusBarHeight);
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    self.hidden = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBtnAndcancelBtnClick)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    //设置添加地址的View
    self.addAddressView = [[UIView alloc]init];
    self.addAddressView.frame = CGRectMake(0, screen_height, screen_width, _defaultHeight);
    self.addAddressView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.addAddressView];
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 10, screen_width - 80, 30)];
    titleLabel.text = _title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = SHP_COLOR_alpha(0x32312D, 1);
    titleLabel.font = SHP_MediumSysFont(17.0);
    [self.addAddressView addSubview:titleLabel];
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame =CGRectMake(CGRectGetMaxX(self.addAddressView.frame) - 40, 10, 30, 30);
    cancelBtn.tag = 1;
    [cancelBtn setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(tapBtnAndcancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.addAddressView addSubview:cancelBtn];
    
    [self addTableViewAndTitle:0];
    //1.添加标题滚动视图
    [self setupTitleScrollView];
    //2.添加内容滚动视图
    [self setupContentScrollView];
    [self setupAllTitle:0];
    return self;
}

#pragma mark - 网络请求
- (void)shp_requestWithAddressID:(NSInteger)addressID
{
    [[SHPNetApiManager sharedManager] shp_requestCheckAreaInfoWithParams:@{@"code":self.code,@"type":[NSNumber numberWithInt:self.typeCode]} block:^(id  _Nonnull data, NSError * _Nonnull error) {
        if ([[data valueForKeyPath:@"code"] isEqual:@0]) {
            [self caseProvinceArr:[data valueForKeyPath:@"data"]];
            if (self.tableViewMarr.count >= addressID){
                UITableView *tableView1  = self.tableViewMarr[addressID - 1];
                [tableView1 reloadData];
            }
        }
    }];
    
}


-(void)addAnimate{
    self.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{
        self.addAddressView.frame = CGRectMake(0, screen_height - self.defaultHeight - SHP_kNavBarAndStatusBarHeight, screen_width, self.defaultHeight);
    }];
}
-(void)tapBtnAndcancelBtnClick{
    self.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{
         self.addAddressView.frame = CGRectMake(0, screen_height, screen_width, self.defaultHeight);
    } completion:^(BOOL finished) {
        self.hidden = YES;
        NSMutableString * titleAddress = [[NSMutableString alloc]init];
        NSMutableString * titleID = [[NSMutableString alloc]init];
        NSInteger  count = 0;
        NSString * str = self.titleMarr[self.titleMarr.count - 1];
        NSString *adCode, *city;
        if ([str isEqualToString:@"请选择"]) {
            count = self.titleMarr.count - 1;
        }
        else{
            count = self.titleMarr.count;
        }
        for (int i = 0; i < count ; i++) {
            [titleAddress appendString:[[NSString alloc] initWithFormat:@" %@",self.titleMarr[i]]];
            if (i == 1) {
                city = self.titleMarr[i];
            }
            if (i == count - 1) {//0==3-1
                [titleID appendString:[[NSString alloc] initWithFormat:@"%@",self.titleIDMarr[i]]];
            }else{
                if (i == 1) {
                    adCode = self.titleIDMarr[i];
                }
            }
        }
        [self.delegate1 cancelBtnClick:titleAddress titleID:titleID adcode:adCode city:city];
    }];
}
-(void)setupTitleScrollView{
    //TitleScrollView和分割线
    self.titleScrollView = [[UIScrollView alloc] init];
    self.titleScrollView.frame = CGRectMake(0, 50, screen_width, _titleScrollViewH);
    [self.addAddressView addSubview:self.titleScrollView];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleScrollView.frame), screen_width, 0.5)];
    lineView.backgroundColor = SHP_COLOR_alpha(0xF2F2F2, 1);
    [self.addAddressView addSubview:(lineView)];
}
-(void)setupContentScrollView{
    //ContentScrollView
    CGFloat y  =  CGRectGetMaxY(self.titleScrollView.frame) + 1;
     self.contentScrollView = [[UIScrollView alloc]init];
    self.contentScrollView.frame = CGRectMake(0, y, screen_width, self.defaultHeight - y);
    [self.addAddressView addSubview:self.contentScrollView];
    self.contentScrollView.delegate = self;
    self.contentScrollView.pagingEnabled = YES;
    self.contentScrollView.bounces = NO;
}
-(void)setupAllTitle:(NSInteger)selectId{
    for ( UIView * view in [self.titleScrollView subviews]) {
         [view removeFromSuperview];
    }
    [self.titleBtns removeAllObjects];
    CGFloat btnH = self.titleScrollViewH;
    _lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 1, 1)];
    _lineLabel.backgroundColor = [UIColor redColor];
    [self.titleScrollView addSubview:(_lineLabel)];
    CGFloat x = 10;
    NSLog(@"%@",self.titleMarr);
    for (int i = 0; i < self.titleMarr.count ; i++) {
        NSString   *title = self.titleMarr[i];
        CGFloat titlelenth = title.length * 15;
        UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [titleBtn setTitle:title forState:UIControlStateNormal];
        titleBtn.tag = i;
        [titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
         [titleBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        titleBtn.selected = NO;
        titleBtn.frame = CGRectMake(x, 0, titlelenth, btnH);
        x  = titlelenth + 10 + x;
        [titleBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
        [titleBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.titleBtns addObject:titleBtn];
        if (i == selectId) {
            [self titleBtnClick:titleBtn];
        }
        [self.titleScrollView addSubview:(titleBtn)];
        self.titleScrollView.contentSize =CGSizeMake(x, 0);
        self.titleScrollView.showsHorizontalScrollIndicator = NO;
        self.contentScrollView.contentSize = CGSizeMake(self.titleMarr.count * screen_width, 0);
        self.contentScrollView.showsHorizontalScrollIndicator = NO;
    }
}
-(void)titleBtnClick:(UIButton *)titleBtn{
    self.radioBtn.selected = NO;
    titleBtn.selected = YES;
    [self setupOneTableView:titleBtn.tag];
    CGFloat x  = titleBtn.tag * screen_width;
    self.contentScrollView.contentOffset = CGPointMake(x, 0);
    self.lineLabel.frame = CGRectMake(CGRectGetMinX(titleBtn.frame), self.titleScrollViewH - 3,titleBtn.frame.size.width, 3);
    self.radioBtn = titleBtn;
    self.isclick = YES;
    }
-(void)setupOneTableView:(NSInteger)btnTag{
    UITableView  * contentView= self.tableViewMarr[btnTag];
    if  (btnTag == 0) {
        if (self.type == SHP_ADDRESS_MINETYPE) {
            [self shp_requestWithAddressID:1];
        }else {//请求所有的
            [self shp_requestAllWithAddressID:1 whitchArea:1 code:@" " typeCode:self.typeCode];
        }
    }
    if (contentView.superview != nil) {
        return;
    }
    CGFloat  x= btnTag * screen_width;
    contentView.frame = CGRectMake(x, 0, screen_width, self.contentScrollView.bounds.size.height);
    contentView.delegate = self;
    contentView.dataSource = self;
    [self.contentScrollView addSubview:(contentView)];
}

#pragma mark- 请求所有的地区
- (void)shp_requestAllWithAddressID:(NSInteger)addressID whitchArea:(NSInteger)area code:(NSString *)code typeCode:(int)typeCode
{
    [[SHPNetApiManager sharedManager] shp_requestCheckAreaInfoAllWithParams:@{@"type":[NSNumber numberWithInt:typeCode],@"code":code}block:^(id  _Nonnull data, NSError * _Nonnull error) {
        if ([[data valueForKeyPath:@"code"] isEqual:@0]) {
            switch (area) {
                case 1:
                    [self caseProvinceArr:[data valueForKeyPath:@"data"]];
                    break;
                case 2:
                    [self caseCityArr:[data valueForKeyPath:@"data"]];
                    break;
                case 3:
                    [self caseCountyArr:[data valueForKeyPath:@"data"]];
                    break;
                default:
                    break;
            }
            if (self.tableViewMarr.count >= addressID){
                UITableView * tableView1  = self.tableViewMarr[addressID - 1];
                [tableView1 reloadData];
            }
        }
    }];
}

-(void)caseCityArr:(NSArray *)cityArr{
    if (cityArr.count > 0){
        [self.cityMarr removeAllObjects];
        for (int i = 0; i < cityArr.count; i++) {
            NSDictionary *dic1 = cityArr[i];
            YXAreaMode *cityModel = [YXAreaMode mj_objectWithKeyValues:dic1];
            [self.cityMarr addObject:cityModel];
        }
        if (self.tableViewMarr.count >= 2){
            [self changeTitle:1];
        }
        else{
            [self addTableViewAndTitle:1];
        }
        [self setupAllTitle:1];
    }
    else{
        //没有对应的市
        [self removeTitleAndTableViewCancel:1];
    }
}

-(void)caseCountyArr:(NSArray *)countyArr{
    if (countyArr.count > 0){
        [self.countyMarr removeAllObjects];
        for (int i = 0; i < countyArr.count; i++) {
            NSDictionary *dic1 = countyArr[i];
            YXAreaMode *countyModel = [YXAreaMode mj_objectWithKeyValues:dic1];
            [self.countyMarr addObject:countyModel];
        }
        if (self.tableViewMarr.count >= 3){
           [self changeTitle:2];
        }
        else{
            [self addTableViewAndTitle:2];
        }
        [self setupAllTitle:2];
    }
    else{
        //没有对应的县
        [self removeTitleAndTableViewCancel:2];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger leftI  = scrollView.contentOffset.x / screen_width;
    if (scrollView.contentOffset.x / screen_width != leftI){
        self.isclick = NO;
    }
    if (self.isclick == NO) {
        if (scrollView.contentOffset.x / screen_width == leftI){
            UIButton * titleBtn  = self.titleBtns[leftI];
            [self titleBtnClick:titleBtn];
        }
    }
}

-(void)caseProvinceArr:(NSArray *)provinceArr{
    if (provinceArr.count > 0){
        [self.provinceMarr removeAllObjects];
        for (int i = 0; i < provinceArr.count; i++) {
            NSDictionary *dic1 = provinceArr[i];
            YXAreaMode *provinceModel =  [YXAreaMode mj_objectWithKeyValues:dic1];
            [self.provinceMarr addObject:provinceModel];
        }
    }else{
        [self tapBtnAndcancelBtnClick];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 0) {
        return self.provinceMarr.count;
    }
    else if (tableView.tag == 1) {
        return self.cityMarr.count;
    }
    else if (tableView.tag == 2){
        return self.countyMarr.count;
    }else{
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * AddressAdministerCellIdentifier = @"AddressAdministerCellIdentifier";
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:AddressAdministerCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AddressAdministerCellIdentifier];
    }
    if (tableView.tag == 0) {
        YXAreaMode * provinceModel = self.provinceMarr[indexPath.row];
        cell.textLabel.text = provinceModel.areaName;
    }
    else if (tableView.tag == 1) {
        YXAreaMode *cityModel = self.cityMarr[indexPath.row];
        cell.textLabel.text= cityModel.areaName;
    }
    else if (tableView.tag == 2){
        YXAreaMode * countyModel  = self.countyMarr[indexPath.row];
        cell.textLabel.text = countyModel.areaName;
    }
    cell.textLabel.font = SHP_RegularSysFont(13.0);
    cell.textLabel.textColor = SHP_COLOR_alpha(0x4A4A4A, 1);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 0 || tableView.tag == 1 || tableView.tag == 2){
        if (tableView.tag == 0){
            YXAreaMode *provinceModel = self.provinceMarr[indexPath.row];
            NSString *provinceID = provinceModel.areaCode;
            //1. 修改选中ID
            if (self.titleIDMarr.count > 0){
                [self.titleIDMarr replaceObjectAtIndex:tableView.tag withObject:provinceID];
            }
            else{
                [self.titleIDMarr addObject:provinceID];
            }
            //2.修改标题
              [self.titleMarr replaceObjectAtIndex:tableView.tag withObject:provinceModel.areaName];
            if (self.typeCode == SHP_CODE_AREA) {//如果直接显示的是区,直接返回
                [self setupAllTitle:tableView.tag];
                [self tapBtnAndcancelBtnClick];
                return;
            }
            [self shp_requestAllWithAddressID:2 whitchArea:2 code:provinceID typeCode:2];
        }else if (tableView.tag == 1){
            YXAreaMode * cityModel = self.cityMarr[indexPath.row];
            NSString * cityID = cityModel.areaCode;
             [self.titleMarr replaceObjectAtIndex:tableView.tag withObject:cityModel.areaName];
            //1. 修改选中ID
            if (self.titleIDMarr.count > 1){
                [self.titleIDMarr replaceObjectAtIndex:tableView.tag withObject:cityID];
            }
            else{
                 [self.titleIDMarr addObject:cityID];
            }
            
            [self shp_requestAllWithAddressID:3 whitchArea:3 code:cityID typeCode:3];
            
        }else if (tableView.tag == 2) {
            YXAreaMode * countyModel = self.countyMarr[indexPath.row];
            NSString * countyID = countyModel.areaCode;
            [self.titleMarr replaceObjectAtIndex:tableView.tag withObject:countyModel.areaName];
            //1. 修改选中ID
            if (self.titleIDMarr.count > 2){
                [self.titleIDMarr replaceObjectAtIndex:tableView.tag withObject:countyID];
            }
            else{
                [self.titleIDMarr addObject:countyID];
            }
            //2.修改标题
            [self.titleMarr replaceObjectAtIndex:tableView.tag withObject:countyModel.areaName];
            
            [self setupAllTitle:tableView.tag];
            [self tapBtnAndcancelBtnClick];
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  40;
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass(touch.view.classForCoder) isEqualToString: @"UITableViewCellContentView"] || touch.view == self.addAddressView || touch.view == self.titleScrollView) {
        return NO;
    }
    return YES;
}
//添加tableView和title
-(void)addTableViewAndTitle:(NSInteger)tableViewTag{
    UITableView * tableView2 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 200) style:UITableViewStylePlain];
    tableView2.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView2.tag = tableViewTag;
    [self.tableViewMarr addObject:tableView2];
    [self.titleMarr addObject:@"请选择"];
}
//改变title
-(void)changeTitle:(NSInteger)replaceTitleMarrIndex{
    [self.titleMarr replaceObjectAtIndex:replaceTitleMarrIndex withObject:@"请选择"];
    NSInteger index = [self.titleMarr indexOfObject:@"请选择"];
    NSInteger count = self.titleMarr.count;
    NSInteger loc = index + 1;
    NSInteger range = count - index;
    [self.titleMarr removeObjectsInRange:NSMakeRange(loc, range - 1)];
    [self.tableViewMarr removeObjectsInRange:NSMakeRange(loc, range - 1)];
}
//移除多余的title和tableView,收回选择器
-(void)removeTitleAndTableViewCancel:(NSInteger)index{
    NSInteger indexAddOne = index + 1;
    NSInteger indexsubOne = index - 1;
    if (self.tableViewMarr.count >= indexAddOne){
        [self.titleMarr removeObjectsInRange:NSMakeRange(index, self.titleMarr.count - indexAddOne)];
        [self.tableViewMarr removeObjectsInRange:NSMakeRange(index, self.tableViewMarr.count - indexAddOne)];
    }
    [self setupAllTitle:indexsubOne];
    [self tapBtnAndcancelBtnClick];
}


@end

