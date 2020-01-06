//
//  YXArrivaltimeView.swift
//  youxuan
//
//  Created by 肖锋 on 2019/11/12.
//  Copyright © 2019 肖锋. All rights reserved.
//

import UIKit

class YXArrivaltimeView: UIView {
    
    var arrivaStr : String?{
        didSet{
            guard let arrivaStr = arrivaStr else { return }
            arrivalContenttimeLabel.text = arrivaStr
        }
    }
    
    
    private lazy var imageView : UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "icon_goods"))
        return imageView
    }()
    
    private lazy var arrivaltimeLabel :  UILabel = {
        let arrivaltimeLabel = UILabel()
        arrivaltimeLabel.textColor = UIColor.YX_getColor(rgbValue: 0x000000)
        arrivaltimeLabel.font = UIFont(name: "PingFang-SC-Semibold", size: 15)
        arrivaltimeLabel.text = "预计到达:"
        arrivaltimeLabel.textAlignment = .left
        return arrivaltimeLabel
    }()
    
    private lazy var arrivalContenttimeLabel :  UILabel = {
        let arrivalContenttimeLabel = UILabel()
        arrivalContenttimeLabel.textColor = UIColor.YX_getColor(rgbValue: 0x4A4A4A)
        arrivalContenttimeLabel.font = UIFont(name: "Helvetica", size: 15)
        arrivalContenttimeLabel.textAlignment = .left
        return arrivalContenttimeLabel
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.YX_getColor(rgbValue: 0xFAFAFA)
        self.layer.cornerRadius = 5
        
        addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.height.width.equalTo(24)
            make.left.equalTo(snp_left).offset(10)
            make.centerY.equalTo(snp_centerY)
        }
        
        addSubview(arrivaltimeLabel)
        arrivaltimeLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(imageView.snp_centerY)
            make.left.equalTo(imageView.snp_right).offset(5)
        }
    
        addSubview(arrivalContenttimeLabel)
        arrivalContenttimeLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(imageView.snp_centerY)
            make.left.equalTo(arrivaltimeLabel.snp_right).offset(5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
