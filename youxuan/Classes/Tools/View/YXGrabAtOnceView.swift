//
//  YXGrabAtOnceView.swift
//  youxuan
//
//  Created by 肖锋 on 2019/11/13.
//  Copyright © 2019 肖锋. All rights reserved.
//

import UIKit

class YXGrabAtOnceView: UIView {
    
    //点击的结果回调
    var clickSelfBlock : (() -> ())?
    
    private lazy var titleLabel : UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "马上抢"
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont(name: "PingFang-SC-Regular", size: 13)
        return titleLabel
    }()
    
    init(frame: CGRect, clickSelfBlock: (() -> ())?) {
        super.init(frame: frame)
        self.clickSelfBlock = clickSelfBlock
        layer.cornerRadius = 14
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 65.5, height: 28)
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.locations = [0,1]
        gradientLayer.colors = [UIColor.YX_getColor(rgbValue: 0xFF657F).cgColor, UIColor.YX_getColor(rgbValue: 0xFF2B41).cgColor]
        layer.addSublayer(gradientLayer)
        clipsToBounds = true
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(snp_centerX)
            make.centerY.equalTo(snp_centerY)
        }
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(YX_clickSelf)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
 
extension YXGrabAtOnceView {
    @objc private func YX_clickSelf(){
        if clickSelfBlock != nil {
            clickSelfBlock!()
        }
    }
}
