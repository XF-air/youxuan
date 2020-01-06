//
//  YXHomeShoppViewModel.swift
//  youxuan
//
//  Created by 肖锋 on 2019/11/4.
//  Copyright © 2019 肖锋. All rights reserved.
//

import UIKit

class YXHomeShoppViewModel {
    
    
    let dGroup = DispatchGroup()
    
    //保存整个模型的数组
    var titles : [YXTitleModel] = []
    
    //分销商品的模型数组
    var retailLists : [YXGoodsModel] = []
    
    //秒杀商品的模型数组
    var spikeActivity : [YXGoodsModel] = []
    
    //home列表的数组
    var homeLists : [YXGoodsModel] = []
    
    //保存标题的数组
    var titleNames = NSMutableArray()
    
    //转模型
    var goodsModel = YXGoodsModel()
    
    
    
}

//数据的请求
extension YXHomeShoppViewModel {
    //总的请求方法
    func YX_requestTotal(finishCallback: @escaping () -> ()) {
        
        YX_requestTitleData()
        
        YX_requestCommodityDistribution()

        YX_requestSpikeActivity()
        
        //总的回调
        
        dGroup.notify(queue: DispatchQueue.main) {
            
            finishCallback()
        }
    }
    
    //获取标题
    private func YX_requestTitleData(){
        dGroup.enter()
        YX_NetWorkRequest(target: .YX_getGoodsList) { (result) in
            if result[YX_ResultCode].stringValue == "0"{
                let titleModel = YXTitleModel()
                titleModel.name = "全部"
                self.titles = YXTitleModel.mj_objectArray(withKeyValuesArray: result["data"].rawValue) as! [YXTitleModel]
                self.titles.insert(titleModel, at: 0)
                for i in 0..<self.titles.count {
                    self.titleNames.add(self.titles[i].name)
                }
            }
            self.dGroup.leave()
        }
    }
    
    //获取分销商的商品信息
    private func YX_requestCommodityDistribution(){
        dGroup.enter()
        YX_NetWorkRequest(target: .YX_getRetailGoods(parameters: NSDictionary.YX_getRetailListDict())) { (result) in
            if result[YX_ResultCode].stringValue == "0"{
                self.retailLists = YXGoodsModel.mj_objectArray(withKeyValuesArray: result["data"]["content"].rawValue) as! [YXGoodsModel]
            }
            self.dGroup.leave()
        }
    }
    
    //获取秒杀活动的信息
    private func YX_requestSpikeActivity(){
        dGroup.enter()
        YX_NetWorkRequest(target: .YX_spikeActivity(parameters: NSDictionary.YX_getRetailListDict())) { (result) in
            if result[YX_ResultCode].stringValue == "0"{
                self.spikeActivity = YXGoodsModel.mj_objectArray(withKeyValuesArray: result["data"]["content"].rawValue) as! [YXGoodsModel]
            }
            self.dGroup.leave()
        }
    }
    
    //获取标题id对应的内容
    func YX_requestTitleContentData(goodsId: String, finishCallback: @escaping () -> ()){
        YX_NetWorkRequest(target: .YX_getAllGoodsList(parameters: NSDictionary.YX_getAllGoodsListDict(page: "1", goodsId: goodsId))) { (result) in
            if result[YX_ResultCode].stringValue == "0"{
                //需要转模型
                self.goodsModel = YXGoodsModel.mj_object(withKeyValues: result["data"].dictionaryObject)
                self.homeLists = YXGoodsModel.mj_objectArray(withKeyValuesArray: result["data"]["goodsInfos"]["content"].rawValue) as! [YXGoodsModel]
            }
            finishCallback()
        }
    }
}
