//
//  YXBannerModel.swift
//  youxuan
//
//  Created by 肖锋 on 2019/11/8.
//  Copyright © 2019 肖锋. All rights reserved.
//

import UIKit

class YXBannerModel: NSObject {
    
    @objc var imgUrl : String = ""
    
    @objc var detailsUrl : String = ""
    
    @objc var details : String = ""
    
    @objc var bannerId : String = ""
    
    override class func mj_replacedKeyFromPropertyName() -> [AnyHashable : Any]! {
        return ["bannerId":"id"]
    }

}
