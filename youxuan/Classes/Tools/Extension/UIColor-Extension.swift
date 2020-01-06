//
//  UIColor-Extension.swift
//  youxuan
//
//  Created by 肖锋 on 2019/10/14.
//  Copyright © 2019年 肖锋. All rights reserved.
//

import UIKit

extension UIColor {
    //给颜色值设置一个构造方法(alpha默认有参数)
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat = 1) {
        self.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: alpha)
    }
    
    //提供一个类方法，根据传递的色值，快速创建颜色(alpha默认有参数)
    class func YX_getColor(rgbValue : UInt64, alpha: CGFloat = 1) -> UIColor {
        return UIColor(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0, green: CGFloat((rgbValue & 0xFF00) >> 8) / 255.0, blue: CGFloat(rgbValue & 0xFF) / 255.0, alpha: alpha)
    }
    
    //提供一个类方法，让外面快速生成一个随机颜色
    class func YX_getRandomColor() -> UIColor {
        return UIColor(r: CGFloat(arc4random_uniform(256)), g: CGFloat(arc4random_uniform(256)), b: CGFloat(arc4random_uniform(256)))
    }
}
