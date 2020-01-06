//
//  YXLoginViewModel.swift
//  youxuan
//
//  Created by 肖锋 on 2019/10/14.
//  Copyright © 2019年 肖锋. All rights reserved.
//

import UIKit
protocol YXLoginViewModelDelegate : class {
    func YXLoginViewModelDelegate()
}
class YXLoginViewModel {
    
    //定义一个属性，用来接收手机号码
    var phoneNumber : String?
    
    //定义一个属性,用来接收验证码
    var code : String?
    
    //设置代理
    weak var delegate : YXLoginViewModelDelegate?
    
    let dGroup = DispatchGroup()
    
    var resultBool : Bool?
    
}


//请求验证码
extension YXLoginViewModel {
    func YX_getCode(finishCallback:@escaping ()->()) {
        YX_NetWorkRequest(target: .YX_getCode(parameters: NSDictionary.YX_getCodeDict(string: phoneNumber!))) { (result) in
            self.delegate?.YXLoginViewModelDelegate()
            finishCallback()
        }
    }
}

//登录
extension YXLoginViewModel {
    func YX_requestLogin(finishCallback:@escaping ()->()) {
        
        YX_login()

        dGroup.notify(queue: DispatchQueue.main) {
            print("请求完毕")
            finishCallback()
        }
    }
}

extension YXLoginViewModel {
    func YX_login() {
        var parametersDict = NSDictionary.YX_geDeviceAndAppMessageDict()
        parametersDict["mobileNumber"] = phoneNumber?.replacingOccurrences(of: " ", with: "")
        parametersDict["validationCode"] = code
        parametersDict["registerWay"] = "0"
        parametersDict["channel"] = "2"
        parametersDict["identity"] = "1"
        parametersDict["type"] = "mobile"
        parametersDict["jgregId"] = ""
        dGroup.enter()
        YX_NetWorkRequest(target: .YX_login(parameters: parametersDict)) { (result) in
            print("打印登录后的信息:\(result["data"]["token"].stringValue)")
            YXUserDefulatTools.YX_saveUserDefult(key: result["data"]["token"].stringValue)
            print("登录完成")
            self.YX_requestCheckBusinessMessage()
        }
    }
}

//查询店铺是否已经添加了
extension YXLoginViewModel {
    func YX_requestCheckBusinessMessage() {
        YX_NetWorkRequest(target: .YX_checkShopp) { (result) in
            print("打印获取的店铺信息:\(result["data"].dictionaryObject ?? ["name":"没有店铺信息"])")
            //这里需要保存code
            YXUserDefulatTools.YX_saveCodeUserDefult(key: result["data"]["cityCode"].stringValue)
            if result["data"].dictionaryObject == nil {
                self.resultBool = true
            }else {
                self.resultBool = false
            }
            print("获取店铺完成")
            self.dGroup.leave()
        }
    }
}
