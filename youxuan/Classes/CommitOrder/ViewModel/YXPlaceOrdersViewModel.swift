//
//  YXPlaceOrdersViewModel.swift
//  youxuan
//
//  Created by 肖锋 on 2019/11/19.
//  Copyright © 2019 肖锋. All rights reserved.
//

import UIKit

enum YXORDERTYPE: Int {
    case YXORDERTYPE_NORMAL = 101 //商城下单
    case YXORDERTYPE_ACTIVITY = 111 //活动订单
    case YXORDERTYPE_DISTRIBUTION = 121 //分销订单
}

class YXPlaceOrdersViewModel {
    
    var skuId : String = ""
    
    var weight : String = ""
    
    var placeOrdersModel = YXPlaceOrdersModel()
    
    let orderType = YXORDERTYPE.YXORDERTYPE_NORMAL
    
    var basePayModel = YXBasePayModel()
    
    
    
}

//获取下单页面的信息
extension YXPlaceOrdersViewModel {
    func YX_getPlaceOrdersData(finishCallback: @escaping () -> ()) {
        let parameters = [
                            "skuId":skuId,
                            "weight":weight,
                            "activityGoodsId":" ",
                            "orderTypeSub":"101",
                            "nbstate":"1",
                            "userCouponId":" "]
        YX_NetWorkRequest(target: .YX_getPlaceOrdersCost(parameters: parameters)) { (result) in
            self.placeOrdersModel = YXPlaceOrdersModel.mj_object(withKeyValues: result["data"].dictionaryObject)
            finishCallback()
        }
    }
    
    func YX_commitCreatOrder(finishCallback: @escaping () -> ()) {
        let parameters = [
                            "skuId":skuId,
                            "channel":"2",
                            "orderContent":" ",
                            "addressId":placeOrdersModel.addressId,
                            "weight":weight,
                            "orderTypeSub":NSNumber(value: orderType.rawValue),
                            "activityGoodsId":" ",
                            "nbCount":" ",
                            "userCouponId":" ",
                            "dispatchingType":" "] as [String : Any]
        YX_NetWorkRequest(target: .YX_creatOrder(parameters: parameters)) { (result) in
            self.basePayModel = YXBasePayModel.mj_object(withKeyValues: result["data"].dictionaryObject)
            finishCallback()
        }
    }
}
