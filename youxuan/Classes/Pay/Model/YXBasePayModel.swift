//
//  YXBasePayModel.swift
//  youxuan
//
//  Created by 肖锋 on 2019/11/25.
//  Copyright © 2019 肖锋. All rights reserved.
//

import UIKit

class YXBasePayModel: NSObject {
    
    @objc var orderAmt : String = ""
    
    @objc var orderId : String = ""
    
    @objc var timeRemaining : Int = 0
    
    @objc var app_id : String = ""
    
    @objc var partner_id : String = ""
    
    @objc var prepay_id : String = ""
    
    @objc var nonceStr : String = ""
    
    @objc var timeStamp : String = ""
    
    @objc var packageStr : String = ""
    
    @objc var paySign : String = ""

}
