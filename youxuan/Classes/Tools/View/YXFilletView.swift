//
//  YXFilletView.swift
//  youxuan
//
//  Created by 肖锋 on 2019/11/11.
//  Copyright © 2019 肖锋. All rights reserved.
//

import UIKit

class YXFilletView: UIView {

    init(frame: CGRect, corner: UIRectCorner, size: CGSize) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
        
        self.layer.mask = YXBaseTools.YX_configRectCorner(view: self, corner: corner, cornerRadii: size)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
