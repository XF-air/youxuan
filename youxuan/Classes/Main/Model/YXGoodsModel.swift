//
//  YXGoodsModel.swift
//  youxuan
//
//  Created by 肖锋 on 2019/11/7.
//  Copyright © 2019 肖锋. All rights reserved.
//

import UIKit

class YXGoodsModel: NSObject {
    
    @objc var goodsId : String = ""
    
    @objc var image : String = ""
    
    @objc var nbCount : String = ""
    
    @objc var price : String = ""
    
    @objc var retailPrice : String = ""
    
    @objc var salesCount : String = ""
    
    @objc var skuId : String = ""
    
    @objc var stock : String = ""
    
    @objc var unitMeasure : Int = 0//计量单位 1 斤 2 箱 3 两 4 盒
    
    @objc var name : String = ""
    
    @objc var salesUnit : Int = 0//购买单位
    
    @objc var skuTypeId : String = ""
    
    @objc var imgs : String = ""//图片列表
    
    @objc var details : String = ""//图文详情
    
    @objc var estimatedTime : String = ""//送货时间
    
    @objc var cumsumCount : Int = 0//购买累加数量
    
    @objc var activityAllStock : String = ""
    
    @objc var activityPrice : String = ""
    
    @objc var activityStock : String = ""
    
    @objc var activityType : String = ""
    
    @objc var buyLimit : String = ""
    
    @objc var endDate : String = ""
    
    @objc var flag : String = ""
    
    @objc var goodsSkuId : String = ""
    
    @objc var ctivityGoodsId : String = ""
    
    @objc var sellStock : String = ""
    
    @objc var status : String = ""
    
    @objc var timeEnd : String = ""
    
    @objc var timeRemaining : Int = 0
    
    @objc var timeStart : String = ""
    
    @objc var virtualAllStock : String = ""
    
    @objc var virtualStock : String = ""
    
    @objc var unit : String = ""
    
    @objc var intro : String = ""
    
    override class func mj_replacedKeyFromPropertyName() -> [AnyHashable : Any]! {
        return ["ctivityGoodsId":"id"]
    }

}
