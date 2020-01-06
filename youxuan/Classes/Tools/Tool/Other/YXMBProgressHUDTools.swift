//
//  YXMBProgressHUDTools.swift
//  youxuan
//
//  Created by 肖锋 on 2019/10/18.
//  Copyright © 2019 肖锋. All rights reserved.
//

import UIKit
import MBProgressHUD

class YXMBProgressHUDTools {

    //传入message
    class func YX_presentHudWithMessage(message : String) {
        let hud = MBProgressHUD.showAdded(to: ((UIApplication.shared.delegate?.window)!)!, animated: true)
        hud.detailsLabel.text = message
        hud.contentColor = UIColor.white
        hud.detailsLabel.font = UIFont(name: "PingFang-SC-Regular", size: 15)
        hud.bezelView.color = UIColor.YX_getColor(rgbValue: 0x000000)
        hud.mode = .text
        hud.removeFromSuperViewOnHide = true
        hud.hide(animated: true, afterDelay: 2)
        hud.margin = 10
        hud.minSize = CGSize(width: 107, height: 30)
        hud.bezelView.layer.cornerRadius = 18.8
    }
}
