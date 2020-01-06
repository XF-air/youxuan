//
//  YXNavigationController.swift
//  youxuan
//
//  Created by 肖锋 on 2019/10/14.
//  Copyright © 2019年 肖锋. All rights reserved.
//

import UIKit
import RTRootNavigationController

class YXNavigationController: RTRootNavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}
//对跳转的控制器做设置
extension YXNavigationController {
    //重写系统的push方法
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if children.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }else {
            viewController.hidesBottomBarWhenPushed = false
        }
        //调用父类
        super.pushViewController(viewController, animated: animated)
    }
}
