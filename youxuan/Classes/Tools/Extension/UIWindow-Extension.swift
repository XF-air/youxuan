//
//  UIWindow-Extension.swift
//  youxuan
//
//  Created by 肖锋 on 2019/11/1.
//  Copyright © 2019 肖锋. All rights reserved.
//

import Foundation
import UIKit

extension UIWindow {
    func YX_layoutInsets() -> UIEdgeInsets {
        if #available(iOS 11.0, *) {
            let safeAreaInsets: UIEdgeInsets = self.safeAreaInsets
            if safeAreaInsets.bottom > 0 {
                return safeAreaInsets
            }
            return UIEdgeInsets.init(top: 20, left: 0, bottom: 0, right: 0)
        }
        return UIEdgeInsets.init(top: 20, left: 0, bottom: 0, right: 0)
    }

    func YX_navigationHeight() -> CGFloat {
        let statusBarHeight = YX_layoutInsets().top
        return statusBarHeight + 44
    }
    
    func YX_bottomHeight() -> Float {
        var navh: Float = 0.0
        
        if #available(iOS 11.0, *) {
            navh += Float((UIApplication.shared.delegate?.window?!.safeAreaInsets.bottom)!)
        }else{
            navh += 0
        }
        return navh
    }
}
