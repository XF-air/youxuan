//
//  YXTextField.swift
//  youxuan
//
//  Created by 肖锋 on 2019/10/14.
//  Copyright © 2019年 肖锋. All rights reserved.
//

import UIKit

class YXTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        if #available(iOS 12.0, *) {
            self.textContentType = UITextContentType.oneTimeCode
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        UIMenuController.shared.isMenuVisible = false
        if action == #selector(copy(_:)) {
            return false
        }else if action == #selector(selectAll(_:)) {
            return false
        }
        return false
    }

}
