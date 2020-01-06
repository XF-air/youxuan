//
//  YXBaseViewController.swift
//  youxuan
//
//  Created by 肖锋 on 2019/10/14.
//  Copyright © 2019年 肖锋. All rights reserved.
//

import UIKit

class YXBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.YX_getColor(rgbValue: 0xF5F6F7)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.navigationController != nil {
            let navBarHairlineImageView = self.findHairlineImageViewUnder(sView: self.navigationController!.navigationBar)
            navBarHairlineImageView.isHidden = true
        }
    }
    
    func findHairlineImageViewUnder(sView: UIView) ->UIImageView {
        if sView.isKind(of: UIImageView.self) && sView.bounds.height <= 1 {
            return sView as! UIImageView
        }
        for sview in sView.subviews {
            let imgs = self.findHairlineImageViewUnder(sView: sview)
            if imgs.isKind(of: UIImageView.self) && imgs.bounds.height <= 1 {
                return imgs
            }
        }
        return UIImageView.init()
    }
}


extension YXBaseViewController {
    override func rt_customBackItem(withTarget target: Any!, action: Selector!) -> UIBarButtonItem! {
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named: "icon_nav_back2"), for: .normal)
        backButton.sizeToFit()
        backButton.addTarget(target, action: action, for: .touchUpInside)
        return UIBarButtonItem(customView: backButton)
    }
}
