//
//  YXMineViewModel.swift
//  youxuan
//
//  Created by 肖锋 on 2019/10/22.
//  Copyright © 2019 肖锋. All rights reserved.
//

import UIKit

class YXMineViewModel {
    var mineModel = YXMineModel()
}

//查询店铺信息
extension YXMineViewModel {
    func YX_requestBusinessMessage(finishCallback: @escaping () -> ()) {
        YX_NetWorkRequest(target: .YX_checkShopp) { (result) in
            //取值,并转成模型
            if result["data"].dictionaryObject != nil {
                self.mineModel.mj_setKeyValues(result["data"].dictionaryObject)
                YXUserDefulatTools.YX_saveCodeUserDefult(key: self.mineModel.cityCode)
            }
            self.YX_requestPickUpGoods(finishCallback: finishCallback)
        }
    }
    
    private func YX_requestPickUpGoods(finishCallback: @escaping () -> ()) {
        YX_NetWorkRequest(target: .YX_getNb(parameters: NSDictionary.YX_getNbDict())) { (result) in
            if result["data"].dictionaryObject != nil {
                self.mineModel.balance = result["data"].dictionaryObject?["balance"] as! Int
            }
            finishCallback()
        }
    }
    
    //调用接口退出登录
    func YX_requestLoginOut(finishCallback: @escaping () -> ())  {
        YX_NetWorkRequest(target: .YX_loginOut) { (result) in
            finishCallback()
        }
    }
}
