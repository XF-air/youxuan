//
//  YXLocationTitleView.swift
//  youxuan
//
//  Created by 肖锋 on 2019/10/31.
//  Copyright © 2019 肖锋. All rights reserved.
//

import UIKit

class YXLocationTitleView: UIView {
    
    private lazy var locationImageView : UIImageView = {
        let locationImageView = UIImageView(image: UIImage(named: "icon_location2"))
        return locationImageView
    }()
    
    private lazy var locationTitleLabel : UILabel = {
        let locationTitleLabel = UILabel()
        locationTitleLabel.text = "正在定位..."
        locationTitleLabel.textColor = UIColor.YX_getColor(rgbValue: 0x4A4A4A)
        locationTitleLabel.font = UIFont(name: "PingFang-SC-Regular", size: 15)
        return locationTitleLabel
    }()
    
    private var locationViewBlock : (() -> ())?
    
    init(frame: CGRect, locationViewBlock: (() -> ())?) {
        super.init(frame: frame)
        
        self.locationViewBlock = locationViewBlock
        
        YX_setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension YXLocationTitleView {
    private func YX_setUpUI(){
        addSubview(locationImageView)
        locationImageView.snp.makeConstraints { (make) in
            make.left.equalTo(snp_left).offset(12)
            make.height.width.equalTo(18)
            make.centerY.equalTo(snp_centerY)
        }
        addSubview(locationTitleLabel)
        locationTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(locationImageView.snp_right)
            make.centerY.equalTo(locationImageView.snp_centerY)
            make.right.equalTo(snp_right)
        }
    }
}
