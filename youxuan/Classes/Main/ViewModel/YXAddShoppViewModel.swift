//
//  YXAddShoppViewModel.swift
//  youxuan
//
//  Created by 肖锋 on 2019/10/24.
//  Copyright © 2019 肖锋. All rights reserved.
//

import UIKit

class YXAddShoppViewModel {
    
    var configVal : String = ""
    
    var chooseArealModel = YXChooseAreaModel()
    
    var mineModel = YXMineModel()
    
    //定义一个数组,将模型添加到数组中
    var businessArrayM : NSMutableArray = NSMutableArray()
    
}


//查询邀请码是不是必须传的
extension YXAddShoppViewModel {
    func YX_requestInvitationCode(finishCallback: @escaping () -> () ) {
        YX_NetWorkRequest(target: .YX_getInvitationCode(parameters: NSDictionary.YX_getInvitationCodeDict())) { (result) in
            guard let configVal = result["data"].dictionaryObject?["configVal"] else { return }
            self.configVal = configVal as! String
            finishCallback()
        }
    }
}

//上传图片
extension YXAddShoppViewModel {
    func YX_upLoadPictures(dataArray: NSMutableArray, finishCallback: @escaping () -> ()) {
        YX_NetWorkRequest(target: .YX_uploadPictures(dataArry: dataArray)) { (result) in
            if result["data"].dictionaryObject?.count != 0 {//表示上传成功,调用添加商铺的接口
                print("图片:\(result["data"].stringValue)")
                self.YX_commitAddShopp(finishCallback: finishCallback, imageDataArray: result["data"].arrayObject! as NSArray)
            }
        }
    }
}

//添加商铺的数据提交
extension YXAddShoppViewModel {
    private func YX_commitAddShopp(finishCallback: @escaping () -> (), imageDataArray: NSArray) {
        let parameters = [
                        "businessName":chooseArealModel.shopName,
                        "name":chooseArealModel.name,
                        "districtCode":chooseArealModel.districtCode,
                        "address":chooseArealModel.address,
                        "inviteCode":chooseArealModel.invitationCode,
                        "businessLicense":imageDataArray[0],
                        "shopFrontImg":imageDataArray[1]
                        ]
        YX_NetWorkRequest(target: .YX_addShoppMessage(parameters: parameters)) { (result) in
            if result["code"].stringValue == "0" {
                finishCallback()
            }
        }
    }
}

//获取商铺信息
extension YXAddShoppViewModel {
    func YX_requestBusinessMessage(finishCallback: @escaping () -> ()){
        YX_NetWorkRequest(target: .YX_checkShopp) { (result) in
            //取值,并转成模型
            if result["data"].dictionaryObject != nil {
                self.businessArrayM.removeAllObjects()
                self.mineModel = YXMineModel.mj_object(withKeyValues: result["data"].dictionaryObject)
                YXUserDefulatTools.YX_saveCodeUserDefult(key: self.mineModel.cityCode)
                for _ in 0..<5 {
                    self.businessArrayM.add(self.mineModel)
                }
            }
            finishCallback()
        }
    }
}

//修改商铺信息
extension YXAddShoppViewModel {
    func YX_requestModifyShopMessage(businessName: String, name: String, districtCode: String, address: String, finishCallback: @escaping () -> ()) {
        let parameters = [
                        "businessName":businessName,
                        "name":name,
                        "districtCode":districtCode,
                        "address":address,
                        "businessLicense":mineModel.businessLicense,
                        "shopFrontImg":mineModel.shopFrontImg
                        ]
        YX_NetWorkRequest(target: .YX_updateBusiness(parameters: parameters)) { (result) in
            finishCallback()
        }
    }
}


