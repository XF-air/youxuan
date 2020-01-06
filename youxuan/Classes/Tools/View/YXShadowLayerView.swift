//
//  YXShadowLayerView.swift
//  youxuan
//
//  Created by 肖锋 on 2019/11/12.
//  Copyright © 2019 肖锋. All rights reserved.
//

import UIKit

class YXShadowLayerView: UIView {

    init(frame: CGRect, shadowColor: UIColor, offset: CGSize) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = offset
        layer.shadowOpacity = 1
        layer.shadowOpacity = 10
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
