//
//  YXOrdersBaseView.swift
//  youxuan
//
//  Created by 肖锋 on 2019/11/19.
//  Copyright © 2019 肖锋. All rights reserved.
//

import UIKit

class YXOrdersBaseView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        layer.cornerRadius = 10
        layer.shadowColor = UIColor.YX_getColor(rgbValue: 0xF2F2F2).cgColor
        layer.shadowOffset = CGSize(width: 0, height: 7)
        layer.shadowOpacity = 1
        layer.shadowRadius = 12
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
