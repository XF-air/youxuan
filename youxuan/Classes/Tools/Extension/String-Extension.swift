//
//  String-Extension.swift
//  youxuan
//
//  Created by 肖锋 on 2019/10/15.
//  Copyright © 2019年 肖锋. All rights reserved.
//

import UIKit

extension String {
    subscript(index:Int) -> String
    {
        get{
            return String(self[self.index(self.startIndex, offsetBy: index)])
        }
        set{
            let tmp = self
            self = ""
            for (idx, item) in tmp.enumerated() {
                if idx == index {
                    self += "\(newValue)"
                }else{
                    self += "\(item)"
                }
            }
        }
    }
    
    func YX_modifyNumberColor(color: UIColor,
                          font: UIFont,
                          regx: String = "([0-9]\\d*\\.?:\\d*)") -> NSMutableAttributedString {
            let attributeString = NSMutableAttributedString(string: self)
            do {
                // 数字正则表达式
                let regexExpression = try NSRegularExpression(pattern: regx, options: NSRegularExpression.Options())
                let result = regexExpression.matches(
                    in: self,
                    options: NSRegularExpression.MatchingOptions(),
                    range: NSMakeRange(0, count)
                )
                for item in result {
                    attributeString.setAttributes(
                        [.foregroundColor : color, .font: font],
                        range: item.range
                    )
                }
            } catch {
                print("Failed with error: \(error)")
            }
            return attributeString
        }
}
