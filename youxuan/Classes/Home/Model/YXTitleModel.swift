//
//  YXTitleItem.swift
//  youxuan
//
//  Created by 肖锋 on 2019/11/4.
//  Copyright © 2019 肖锋. All rights reserved.
//

import UIKit

class YXTitleModel: NSObject {
    
    @objc var name : String = ""
    
    @objc var shoppTitleModel_id : String = " "
    
    override class func mj_replacedKeyFromPropertyName() -> [AnyHashable : Any]! {
        return ["shoppTitleModel_id":"id"]
    }
}
