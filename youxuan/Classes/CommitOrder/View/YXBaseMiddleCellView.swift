//
//  YXBaseMiddleCellView.swift
//  youxuan
//
//  Created by 肖锋 on 2019/11/20.
//  Copyright © 2019 肖锋. All rights reserved.
//

import UIKit

class YXBaseMiddleCellView: UIView {
    
    var couponPlaceOrdersModel : YXPlaceOrdersModel?{
        didSet{
            guard let couponPlaceOrdersModel = couponPlaceOrdersModel else { return }
            if couponPlaceOrdersModel.discount.count != 0 {
                couponCountLabel.text = "-\(couponPlaceOrdersModel.discount)"
                couponCountLabel.textColor = UIColor.YX_getColor(rgbValue: 0xFB3F52)
                self.isUserInteractionEnabled = true
            }else {
                if couponPlaceOrdersModel.couponCount != "0" {
                    couponCountLabel.text = "\(couponPlaceOrdersModel.couponCount)张可用"
                    couponCountLabel.textColor = UIColor.YX_getColor(rgbValue: 0xFB3F52)
                    self.isUserInteractionEnabled = true
                }else {
                    couponCountLabel.text = "暂无可用"
                    couponCountLabel.textColor = UIColor.YX_getColor(rgbValue: 0xB4B4B4)
                    self.isUserInteractionEnabled = false
                }
            }
        }
    }
    
    var placeOrdersModel : YXPlaceOrdersModel?{
        didSet{
            guard let placeOrdersModel = placeOrdersModel else { return }
            contentLabel.text = "(可用\(placeOrdersModel.nbCount)牛币抵用\(placeOrdersModel.nbCountValue)元)"
            if placeOrdersModel.nbCount == 0 && placeOrdersModel.nbCountValue == 0{
                self.isUserInteractionEnabled = false
            }else {
                self.isUserInteractionEnabled = true
            }
        }
    }
    
    
    var isNbBool : Bool = false
    
    private var clickSelfBlock : (() -> ())?
    
    private lazy var imageView : UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var titleLabel : UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.YX_getColor(rgbValue: 0x32312D)
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont(name: "PingFang-SC-Medium", size: 16)
        return titleLabel
    }()
    
    private lazy var contentLabel : UILabel = {
        let contentLabel = UILabel()
        contentLabel.textColor = UIColor.YX_getColor(rgbValue: 0xB4B4B4)
        contentLabel.textAlignment = .left
        contentLabel.font = UIFont(name: "PingFang-SC-Light", size: 13)
        return contentLabel
    }()
    
    private lazy var arrowImageView : UIImageView = {
        let arrowImageView = UIImageView()
        return arrowImageView
    }()
    
    private lazy var btn : UIButton = {
       let btn = UIButton()
        btn.setImage(UIImage(named: "list_choicebox_nor"), for: .normal)
        btn.setImage(UIImage(named: "list_choicebox_sel"), for: .selected)
        btn.adjustsImageWhenHighlighted = false
        btn.isSelected = false
        btn.addTarget(self, action: #selector(YX_chooseNbClick), for: .touchUpInside)
        return btn
    }()
    
    private lazy var couponCountLabel : UILabel = {
        let couponCountLabel = UILabel()
        couponCountLabel.textAlignment = .right
        couponCountLabel.font = UIFont(name: "PingFang-SC-Regular", size: 13)
        return couponCountLabel
    }()
    
    init(frame: CGRect, isNbBool: Bool, clickSelfBlock: (() -> ())?) {
        super.init(frame: frame)
        self.clickSelfBlock = clickSelfBlock
        self.isNbBool = isNbBool
        YX_setUpUI()
        if isNbBool {
            imageView.image = UIImage(named: "icon_discount")
            titleLabel.text = "牛币"
            contentLabel.isHidden = false
            addSubview(btn)
            btn.snp.makeConstraints { (make) in
                make.right.equalTo(snp_right).offset(-8)
                make.height.width.equalTo(24)
                make.centerY.equalTo(snp_centerY)
            }
        }else {
            imageView.image = UIImage(named: "icon_coupon")
            titleLabel.text = "优惠券"
            contentLabel.isHidden = true
            addSubview(arrowImageView)
            arrowImageView.image = UIImage(named: "icon_more1")
            arrowImageView.snp.makeConstraints { (make) in
                make.right.equalTo(snp_right).offset(-5)
                make.width.height.equalTo(24)
                make.centerY.equalTo(snp_centerY)
            }
            addSubview(couponCountLabel)
            couponCountLabel.snp.makeConstraints { (make) in
                make.centerY.equalTo(arrowImageView.snp_centerY)
                make.right.equalTo(arrowImageView.snp_left)
            }
        }
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(YX_chooseNbClick)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension YXBaseMiddleCellView {
    private func YX_setUpUI(){
        addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.left.equalTo(snp_left).offset(10)
            make.width.height.equalTo(18)
            make.centerY.equalTo(snp_centerY)
        }
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(imageView.snp_right).offset(3)
            make.centerY.equalTo(snp_centerY)
        }
        addSubview(contentLabel)
        contentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp_right).offset(5)
            make.centerY.equalTo(snp_centerY)
        }
    }
}

extension YXBaseMiddleCellView {
    @objc private func YX_chooseNbClick(){
        if self.isNbBool {
            if !btn.isSelected {
                btn.isSelected = true
            }else {
                btn.isSelected = false
            }
        }else {
            if clickSelfBlock != nil {
                clickSelfBlock!()
            }
        }
    }
}
