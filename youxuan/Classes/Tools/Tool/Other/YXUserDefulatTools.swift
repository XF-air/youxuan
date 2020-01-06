//
//  YXUserDefulatTools.swift
//  youxuan
//
//  Created by 肖锋 on 2019/10/16.
//  Copyright © 2019年 肖锋. All rights reserved.
//

import UIKit

class YXUserDefulatTools {
    
    //存TOKEN
    class func YX_saveUserDefult(key : String) {
        let defult = UserDefaults.standard
        defult.set(key, forKey: "YX_LOGIN_TOKEN")
        defult.synchronize()
    }
    
    //取TOKEN
    class func YX_getUserDefult() -> (String?) {
        guard let token = UserDefaults.standard.object(forKey: "YX_LOGIN_TOKEN") as? String else { return nil }
        return token
    }
    
    //保存地区值
    class func YX_saveCodeUserDefult(key: String){
        UserDefaults.standard.set(key, forKey: "YX_CODE")
        UserDefaults.standard.synchronize()
    }
    
    //读取地区编码
    class func YX_getCodeUserDeflut() -> String {
        if (UserDefaults.standard.object(forKey: "YX_CODE") as? String) == nil {
            return "未读取到保存的编码"
        }
        return UserDefaults.standard.object(forKey: "YX_CODE") as! String
    }
    
    //移除相关信息
    class func YX_removeUserDefult() {
        UserDefaults.standard.removeObject(forKey: "YX_LOGIN_TOKEN")
        UserDefaults.standard.removeObject(forKey: "YX_CODE")
        UserDefaults.standard.synchronize()
    }
}
