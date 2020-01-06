//
//  MainTabBarController.swift
//  youxuan
//
//  Created by 肖锋 on 2019/10/12.
//  Copyright © 2019年 肖锋. All rights reserved.
//

import UIKit
import CYLTabBarController

class MainTabBarController: CYLTabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.delegate = self
        
        
    }
    
}

extension MainTabBarController {
    private func YX_setUpContentControl(){

        
    }
    
    override func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        self.updateSelectionStatusIfNeeded(for: tabBarController, shouldSelect: viewController)
        return true
    }
    
}
