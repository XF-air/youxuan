//
//  YXParameters-Extension.swift
//  youxuan
//
//  Created by 肖锋 on 2019/10/15.
//  Copyright © 2019年 肖锋. All rights reserved.
//

import UIKit

extension NSDictionary {
    
    class func YX_getInvitationCodeDict() -> ([String : Any]) {
        return ["code":"1001"]
    }

    class func YX_getNbDict() -> ([String : Any]) {
        return ["accKind":"1"]
    }
    
    class func YX_getCodeDict(string: String) -> ([String : Any]){
        return ["mobile":string.replacingOccurrences(of: " ", with: "")]
    }
    
    class func YX_getRetailListDict() -> ([String : Any]){
        return [
            "cityCode":YXUserDefulatTools.YX_getCodeUserDeflut().count == 0 ? AppDelegate.sharedInstance.adcode : YXUserDefulatTools.YX_getCodeUserDeflut(),
            "page":"1",
            "size":YXSIZEMAX]
    }
    
    class func YX_getAllGoodsListDict(page: String, goodsId: String) -> ([String : Any]){
        return [
            "cityCode":YXUserDefulatTools.YX_getCodeUserDeflut().count == 0 ? AppDelegate.sharedInstance.adcode : YXUserDefulatTools.YX_getCodeUserDeflut(),
            "page":"1",
            "size":YXSIZEMAX,
            "goodsId":goodsId]
    }
    
    class func YX_getBannerListDict() -> ([String : Any]){
        return ["page":"1","size":YXSIZEMAX]
    }
    
    //获取设备信息
    class func YX_geDeviceAndAppMessageDict() -> ([String : String]) {
        
        let infoDict = Bundle.main.object(forInfoDictionaryKey:"CFBundleShortVersionString")
        let currentDevice = UIDevice.current
        
        let dict = [
        "appVersion":infoDict,
        "termModel":NSDictionary.YX_geIphone(),
        "termSystemVersion":currentDevice.systemVersion,
        "termId":currentDevice.identifierForVendor?.uuidString]
        
        return dict as! ([String : String])
    }
    
    //获取设备型号
    private class func YX_geIphone() -> (String){
        var systemInfo = utsname()
        
        uname(&systemInfo)
        
        let deviceString = withUnsafePointer(to: &systemInfo.machine, { (ptr) -> String? in
            let deviceChars = unsafeBitCast(ptr, to: UnsafePointer<CChar>.self)
            return String.init(cString: deviceChars, encoding: .utf8)
        })
        
        let deviceType = [
                        "iPhone4,1" : "iPhone 4S",
                        "iPhone5,1" : "iPhone 5",
                        "iPhone5,2" : "iPhone 5",
                        "iPhone5,3" : "iPhone 5c",
                        "iPhone5,4" : "iPhone 5c",
                        "iPhone6,1" : "iPhone 5s",
                        "iPhone6,2" : "iPhone 5s",
                        "iPhone7,1" : "iPhone 6 Plus",
                        "iPhone7,2" : "iPhone 6",
                        "iPhone8,1" : "iPhone 6s",
                        "iPhone8,2" : "iPhone 6s Plus",
                        "iPhone8,4" : "iPhone SE",
                        "iPhone9,1" : "国行、日版、港行iPhone 7",
                        "iPhone9,3" : "美版、台版iPhone 7",
                        "iPhone9,2" : "港行、国行iPhone 7 Plus",
                        "iPhone9,4" : "美版、台版iPhone 7 Plus",
                        "iPhone10,1" : "国行(A1863)、日行(A1906)iPhone 8",
                        "iPhone10,2" : "国行(A1864)、日行(A1898)iPhone 8 Plus",
                        "iPhone10,3" : "国行(A1865)、日行(A1902)iPhone X",
                        "iPhone10,4" : "美版(Global/A1905)iPhone 8",
                        "iPhone10,5" : "美版(Global/A1897)iPhone 8 Plus",
                        "iPhone10,6" : "美版(Global/A1901)iPhone X",
                        "iPhone11,2" : "iPhone XS",
                        "iPhone11,4" : "iPhone XS Max",
                        "iPhone11,6" : "iPhone XS Max",
                        "iPhone11,8" : "iPhone XR"
                        ]
        
        
        if let deviceStringKey = deviceString
        {
            if deviceStringKey.hasPrefix("x86")
            {
                return "iPhone模拟器，Mac"
            }
            else
            {
                if let deviceTypeString = deviceType[deviceStringKey]
                {
                    return deviceTypeString
                }
            }
        }
        
        return "iPhone新机型"
        }
}
