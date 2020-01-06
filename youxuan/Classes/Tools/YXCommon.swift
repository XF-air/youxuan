//
//  YXCommon.swift
//  youxuan
//
//  Created by 肖锋 on 2019/10/14.
//  Copyright © 2019年 肖锋. All rights reserved.
//

import UIKit

let YXScreenW = UIScreen.main.bounds.width
let YXScreenH = UIScreen.main.bounds.height
let YXREFERSHMINENOTIFICATION = "YXREFERSHMINENOTIFICATION"
let YXRECEIVEDLOCATIONNOTIFICATION = "YXRECEIVEDLOCATIONNOTIFICATION"
let YXPAYSUCESS = "YXPAYSUCESS"

let YXSIZEMAX : Int = 999999

let isPhone = Bool(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone)
let isPhoneX = Bool(YXScreenW >= 375.0 && YXScreenH >= 812.0 && isPhone)

//状态栏高度
let YXstatusBarHeight = UIApplication.shared.statusBarFrame.height

//导航栏高度
let YXnavigationHeight = (YXstatusBarHeight + 44)

//tabbar高度
let YXtabBarHeight = (YXstatusBarHeight == 44 ? 83 : 49)

//顶部的安全距离
let YXtopSafeAreaHeight = (YXstatusBarHeight - 20)

//底部的安全距离
let YXbottomSafeAreaHeight = (YXtabBarHeight - 49)

let release : Int = 0
let pictureUrl = (release == 0 ? "http://files.cs.xundatong.net" : "http://files.cs.niudiapp.com")
let YXScheme : String = "ZKYouXuanAliPay"





