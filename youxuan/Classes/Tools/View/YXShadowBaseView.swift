//
//  YXShadowBaseView.swift
//  youxuan
//
//  Created by 肖锋 on 2019/10/21.
//  Copyright © 2019 肖锋. All rights reserved.
//

import UIKit

class YXShadowBaseView: UIView {

    init(frame: CGRect, shadowColor: UIColor, shadowSize: CGSize, shadowRadius: CGFloat, cornerRadius: CGFloat? = nil) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = shadowSize
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = shadowRadius
        self.layer.cornerRadius = cornerRadius ?? 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
