//
//  YXBasePayViewModel.swift
//  youxuan
//
//  Created by 肖锋 on 2019/11/26.
//  Copyright © 2019 肖锋. All rights reserved.
//

import UIKit
import Alamofire

class YXBasePayViewModel {
    
    var orderId : String = ""
    
    var payWay : Int = 0
    
    var basePayModel = YXBasePayModel()
    
    
}

//数据请求
extension YXBasePayViewModel {
    func YX_sendPay() {
        let  parameters = ["orderId":orderId,
                           "payWay":payWay,
                           "payType":"1",
                           "channel":"1"] as [String : Any]
        let headers = ["Content-Type":"application/json",
        "token":YXUserDefulatTools.YX_getUserDefult() ?? ""]
        Alamofire.request("\(YX_BaseURLStr)/payment/send-pay", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseString(completionHandler: { (response) in
            switch response.result {
            case .success(let json):
                print("json:\(json)")
                if self.payWay == 0 {
                    self.basePayModel = YXBasePayModel.mj_object(withKeyValues: YXBaseTools.YX_stringValueDic(json)!["data"] as! [String : Any])
                    self.YX_weiChatPay()
                }else {
                    self.YX_aliPay(orderInfo: (YXBaseTools.YX_stringValueDic(json)!["data"] as! [String : Any])["order_info"] as! String)
                }
                break
            case .failure(let error):
                print("error:\(error)")
                break
            }
        })
    }
    
    //微信支付
    private func YX_weiChatPay(){
        print("app_id:\(basePayModel.app_id)")
        let req = PayReq()
        req.openID = basePayModel.app_id
        req.partnerId = basePayModel.partner_id
        req.prepayId = basePayModel.prepay_id
        req.nonceStr = basePayModel.nonceStr
        req.timeStamp = UInt32(basePayModel.timeStamp)!
        req.package = basePayModel.packageStr
        req.sign = basePayModel.paySign
        WXApi.send(req)
    }
    
    //支付宝支付
    private func YX_aliPay(orderInfo: String) {
        AlipaySDK.defaultService()?.payOrder(orderInfo, dynamicLaunch: true, fromScheme: YXScheme, callback: { (resultDict) in
            print("请求支付宝成功:\(String(describing: resultDict))")
        })
    }
    
    //取消订单
    func YX_cancelOrder() {
        YX_NetWorkRequest(target: .YX_cancelOrder(parameters: ["orderId":orderId])) { (result) in}
    }
}
