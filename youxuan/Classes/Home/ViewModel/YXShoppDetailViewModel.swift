//
//  YXShoppDetailViewModel.swift
//  youxuan
//
//  Created by 肖锋 on 2019/11/12.
//  Copyright © 2019 肖锋. All rights reserved.
//

import UIKit
import Alamofire

class YXShoppDetailViewModel {
    
    var skuId : String = ""
    
    //保存banner的数组
    var bannerArray : [YXBannerModel] = []
    
    //存bannerUrl的数组
    var bannerUrlArray : [String] = []
    
    //其余数据的模型
    var goodsModel = YXGoodsModel()
    
    var htmlJson : String = ""
    
    
}

//数据请求
extension YXShoppDetailViewModel {
    func YX_getDetail(finishCallback: @escaping () -> ()) {
        YX_NetWorkRequest(target: .YX_getRetailGoodsDetail(parameters: ["skuId":skuId])) { (result) in
            self.goodsModel = YXGoodsModel.mj_object(withKeyValues: result["data"].dictionaryObject)
            //转模型
            self.bannerArray = YXBannerModel.mj_objectArray(withKeyValuesArray: result["data"]["imgs"].rawValue) as! [YXBannerModel]
            //遍历取出url
            if self.bannerArray.count != 0 {
                for i in 0..<self.bannerArray.count {
                    self.bannerUrlArray.append("\(pictureUrl)/\(self.bannerArray[i].imgUrl)")
                }
            }else {
                self.bannerUrlArray.append("\(pictureUrl)/\(self.goodsModel.image)")
            }
            finishCallback()
        }
    }
    
    func YX_getHtmlData(finishCallback: @escaping () -> ()) {
            Alamofire.request("\(YX_BaseURLStr)/retail-goods/details-h5", method: .get, parameters: ["skuId":skuId], encoding: URLEncoding.default, headers: ["Content-Type":"text/html",
            "token":YXUserDefulatTools.YX_getUserDefult() ?? ""]).responseString(completionHandler: { (response) in
                switch response.result {
                case .success(let json):
                    print("-------json:\(json)")
                    self.htmlJson = json
                    break
                case .failure(let error):
                    print("error:\(error)")
                    break
                }
                finishCallback()
            })
    }
    
    //查询是否超出了商品总数
    func YX_getGoodsInfo(finishCallback: @escaping () -> ()) {
        YX_NetworkRequest(target: .YX_getCheckGoodsInfo(parameters: ["skuId":skuId]), succsee: { (succsee) in
            if succsee[YX_ResultCode].stringValue == "0" {
                self.goodsModel = YXGoodsModel.mj_object(withKeyValues: succsee["data"].dictionaryObject)
                finishCallback()
            }
        }, failed: { (failed) in
            
        }) { () -> (Void) in
            
        }
    }
    
}
