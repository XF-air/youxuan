//
//  YXWholeBasketPriceView.swift
//  youxuan
//
//  Created by 肖锋 on 2019/11/12.
//  Copyright © 2019 肖锋. All rights reserved.
//

import UIKit

class YXWholeBasketPriceView: UIView {
    
    var goodsModel : YXGoodsModel?{
        didSet {
            guard let goodsModel = goodsModel else { return }
            wholeBasketPriceLabel.text = "整框售价（\(goodsModel.salesUnit)/\(goodsModel.unit)）"
        }
    }
    
    private lazy var imageView : UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "icon_masg"))
        return imageView
    }()
    
    private lazy var wholeBasketPriceLabel :  UILabel = {
        let wholeBasketPriceLabel = UILabel()
        wholeBasketPriceLabel.textColor = UIColor.YX_getColor(rgbValue: 0xB4B4B4)
        wholeBasketPriceLabel.font = UIFont(name: "PingFang-SC-Regular", size: 10)
        wholeBasketPriceLabel.textAlignment = .left
        return wholeBasketPriceLabel
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.height.width.equalTo(12)
            make.left.equalTo(snp_left)
            make.centerY.equalTo(snp_centerY)
        }
        
        addSubview(wholeBasketPriceLabel)
        wholeBasketPriceLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(imageView.snp_centerY)
            make.left.equalTo(imageView.snp_right).offset(2)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
