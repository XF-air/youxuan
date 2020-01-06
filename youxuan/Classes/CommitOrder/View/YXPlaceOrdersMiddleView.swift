//
//  YXPlaceOrdersMiddleView.swift
//  youxuan
//
//  Created by 肖锋 on 2019/11/19.
//  Copyright © 2019 肖锋. All rights reserved.
//

import UIKit

class YXPlaceOrdersMiddleView: YXOrdersBaseView {
    
    var placeOrdersModel : YXPlaceOrdersModel?{
        didSet{
            guard let placeOrdersModel = placeOrdersModel else { return }
            serviceMiddleContentTimeLabel.text = placeOrdersModel.estimatedTime
            goodsListView.placeOrdersModel = placeOrdersModel
            couponBaseMiddleCellView.couponPlaceOrdersModel = placeOrdersModel
            nbBaseMiddleCellView.placeOrdersModel = placeOrdersModel
        }
    }

    private var commodityClickBlock : (() -> ())?
    
    private var couponClickBlock : (() -> ())?
    
    private var oxCoinClickBlck : (() -> ())?
    
    private lazy var serviceTimeLabel : UILabel = {
        let serviceTimeLabel = UILabel()
        serviceTimeLabel.textAlignment = .left
        serviceTimeLabel.textColor = UIColor.YX_getColor(rgbValue: 0x32312D)
        serviceTimeLabel.font = UIFont(name: "PingFang-SC-Medium", size: 16)
        serviceTimeLabel.text = "送达时间"
        return serviceTimeLabel
    }()
    
    private lazy var serviceContentTimeLabel : UILabel = {
        let serviceContentTimeLabel = UILabel()
        serviceContentTimeLabel.textAlignment = .right
        serviceContentTimeLabel.textColor = UIColor.YX_getColor(rgbValue: 0x4A4A4A)
        serviceContentTimeLabel.font = UIFont(name: "PingFang-SC-Regular", size: 14)
        serviceContentTimeLabel.text = "送达"
        return serviceContentTimeLabel
    }()
    
    private lazy var serviceMiddleContentTimeLabel : UILabel = {
        let serviceMiddleContentTimeLabel = UILabel()
        serviceMiddleContentTimeLabel.textAlignment = .right
        serviceMiddleContentTimeLabel.textColor = UIColor.YX_getColor(rgbValue: 0xF39C13)
        serviceMiddleContentTimeLabel.font = UIFont(name: "PingFang-SC-Medium", size: 14)
        return serviceMiddleContentTimeLabel
    }()
    
    private lazy var serviceLabel : UILabel = {
        let serviceLabel = UILabel()
        serviceLabel.textAlignment = .right
        serviceLabel.textColor = UIColor.YX_getColor(rgbValue: 0x4A4A4A)
        serviceLabel.font = UIFont(name: "PingFang-SC-Regular", size: 14)
        serviceLabel.text = "预计"
        return serviceLabel
    }()
    
    private lazy var goodsListView : YXGoodsListView = {
        let goodsListView = YXGoodsListView(frame: CGRect.zero) {
            
        }
        return goodsListView
    }()
    
    private lazy var couponBaseMiddleCellView : YXBaseMiddleCellView = {
        let couponBaseMiddleCellView = YXBaseMiddleCellView(frame: CGRect.zero, isNbBool: false) {
            if self.couponClickBlock != nil {
                self.couponClickBlock!()
            }
        }
        return couponBaseMiddleCellView
    }()
    
    private lazy var nbBaseMiddleCellView : YXBaseMiddleCellView = {
        let nbBaseMiddleCellView = YXBaseMiddleCellView(frame: CGRect.zero, isNbBool: true) {
            
        }
        return nbBaseMiddleCellView
    }()
    
    init(frame: CGRect, commodityClickBlock : (() -> ())?, couponClickBlock : (() -> ())?, oxCoinClickBlck : (() -> ())?) {
        super.init(frame: frame)
        self.commodityClickBlock = commodityClickBlock
        self.couponClickBlock = couponClickBlock
        self.oxCoinClickBlck = oxCoinClickBlck
        YX_setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension YXPlaceOrdersMiddleView {
    private func YX_setUpUI(){
        addSubview(serviceTimeLabel)
        serviceTimeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(snp_left).offset(10)
            make.top.equalTo(snp_top).offset(15)
        }
        addSubview(serviceContentTimeLabel)
        serviceContentTimeLabel.snp.makeConstraints { (make) in
            make.right.equalTo(snp_right).offset(-10)
            make.centerY.equalTo(serviceTimeLabel.snp_centerY)
        }
        addSubview(serviceMiddleContentTimeLabel)
        serviceMiddleContentTimeLabel.snp.makeConstraints { (make) in
            make.right.equalTo(serviceContentTimeLabel.snp_left).offset(-5)
            make.centerY.equalTo(serviceTimeLabel.snp_centerY)
        }
        addSubview(serviceLabel)
        serviceLabel.snp.makeConstraints { (make) in
            make.right.equalTo(serviceMiddleContentTimeLabel.snp_left).offset(-5)
            make.centerY.equalTo(serviceTimeLabel.snp_centerY)
        }
        addSubview(goodsListView)
        goodsListView.snp.makeConstraints { (make) in
            make.top.equalTo(snp_top).offset(47.5)
            make.height.equalTo(112)
            make.left.equalTo(snp_left)
            make.right.equalTo(snp_right)
        }
        addSubview(couponBaseMiddleCellView)
        couponBaseMiddleCellView.snp.makeConstraints { (make) in
            make.left.equalTo(snp_left)
            make.right.equalTo(snp_right)
            make.top.equalTo(goodsListView.snp_bottom).offset(15)
            make.height.equalTo(22.5)
        }
        
        addSubview(nbBaseMiddleCellView)
        nbBaseMiddleCellView.snp.makeConstraints { (make) in
            make.left.equalTo(snp_left)
            make.right.equalTo(snp_right)
            make.top.equalTo(couponBaseMiddleCellView.snp_bottom).offset(23)
            make.height.equalTo(22.5)
        }
    }
}
