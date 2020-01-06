//
//  YXMineModel.swift
//  youxuan
//
//  Created by 肖锋 on 2019/10/22.
//  Copyright © 2019 肖锋. All rights reserved.
//

import UIKit

class YXMineModel: NSObject {
    
    @objc var mobile : String = ""
    
    @objc var orderCount : Int = 0
    
    @objc var aduitStatus : String = ""
    
    @objc var balance : Int = 0
    
    @objc var address : String = ""
    
    @objc var area : String = ""
    
    @objc var areaCode : String = ""
    
    @objc var businessName : String = ""
    
    @objc var city : String = ""
    
    @objc var cityCode : String = ""
    
    @objc var createTime : String = ""
    
    @objc var inviteCode : String = ""
    
    @objc var name : String = ""
    
    @objc var province : String = ""
    
    @objc var provinceCode : String = ""
    
    @objc var phone : String = ""
    
    @objc var businessLicense : String = ""
    
    @objc var shopFrontImg : String = ""
    
    @objc var aduitRemark : String = ""
    
    @objc var aduitTime : String = ""
    
    @objc var businessMessageItem_id : String = ""
    
    override class func mj_replacedKeyFromPropertyName() -> [AnyHashable : Any]! {
        return ["businessMessageItem_id":"id"]
    }
}
