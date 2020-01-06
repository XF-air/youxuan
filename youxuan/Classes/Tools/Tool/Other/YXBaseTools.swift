//
//  YXBaseTools.swift
//  youxuan
//
//  Created by 肖锋 on 2019/11/8.
//  Copyright © 2019 肖锋. All rights reserved.
//

import UIKit

class YXBaseTools {

    class func YX_configRectCorner(view: UIView, corner: UIRectCorner, cornerRadii: CGSize) -> CALayer {
        
        let maskPath = UIBezierPath.init(roundedRect: view.bounds, byRoundingCorners: corner, cornerRadii: cornerRadii)
        
        let maskLayer = CAShapeLayer.init()
        maskLayer.frame = view.bounds
        maskLayer.path = maskPath.cgPath
        
        return maskLayer
    }
    
    class func YX_originalWithImage(imageName: String) -> (UIImage) {
        return (UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal))!
    }
    
    class func YX_getMMSSFromSSWithRemaining(totalTime: Int) -> (String){
        var hours = 0
        var minutes = 0
        var seconds = 0
        var hoursText = ""
        var minutesText = ""
        var secondsText = ""
        
        hours = totalTime / 3600
        hoursText = hours > 9 ? "\(hours)" : "0\(hours)"
        
        minutes = totalTime % 3600 / 60
        minutesText = minutes > 9 ? "\(minutes)" : "0\(minutes)"
        
        seconds = totalTime % 3600 % 60
        secondsText = seconds > 9 ? "\(seconds)" : "0\(seconds)"
        
        return "\(hoursText):\(minutesText):\(secondsText)"
    }
    
    class func YX_getMMSSFromSS(totalTime: Int) -> (String) {
        let minute = totalTime/60
        let second = totalTime%60
        return "\(minute)分\(second)秒"
    }
    
    class func YX_StringToFloat(str: String) -> (CGFloat) {
        let string = str
        var cgFloat: CGFloat = 0
        if let doubleValue = Double(string)  {
            cgFloat = CGFloat(doubleValue)
        }
        return cgFloat
    }
    
    class func YX_stringToInt(str: String) -> (Int) {
        let string = str
        var int : Int?
        if let doubleValue = Int(string) {
            int = Int(doubleValue)
        }
        if int == nil {
            return 0
        }
        return int!
    }
    
    class func YX_jsonToData(jsonDic:Dictionary<String, Any>) -> Data? {
        if (!JSONSerialization.isValidJSONObject(jsonDic)) {
            print("is not a valid json object")
            return nil
        }
        //利用自带的json库转换成Data
        //如果设置options为JSONSerialization.WritingOptions.prettyPrinted，则打印格式更好阅读
        let data = try? JSONSerialization.data(withJSONObject: jsonDic, options: [])
        //Data转换成String打印输出
        let str = String(data:data!, encoding: String.Encoding.utf8)
        //输出json字符串
        print("Json Str:\(str!)")
        return data
    }
    
    class func YX_stringValueDic(_ str: String) -> [String : Any]?{
        let data = str.data(using: String.Encoding.utf8)
        if let dict = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String : Any] {
            return dict
        }
        return nil
    }
}
