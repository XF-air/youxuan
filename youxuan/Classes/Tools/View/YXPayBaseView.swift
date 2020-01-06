//
//  YXPayBaseView.swift
//  youxuan
//
//  Created by 肖锋 on 2019/11/19.
//  Copyright © 2019 肖锋. All rights reserved.
//

import UIKit

class YXPayBaseView: UIView {
    
    var placeOrdersModel : YXPlaceOrdersModel?{
        didSet{
            guard let placeOrdersModel = placeOrdersModel else { return }
            moneyLabel.text = "\(placeOrdersModel.orderRealAmt)"
        }
    }
    
    private var commitOrderBlock : (() -> ())?
    
    private lazy var moneyLabel : UILabel = {
        let moneyLabel = UILabel()
        moneyLabel.textColor = UIColor.YX_getColor(rgbValue: 0xFB3F52)
        moneyLabel.font = UIFont(name: "PingFang-SC-Medium", size: 25)
        moneyLabel.textAlignment = .left
        return moneyLabel
    }()
    
    init(frame: CGRect, commitOrderBlock: (() -> ())?) {
        super.init(frame: frame)
        
        self.commitOrderBlock = commitOrderBlock
        
        self.backgroundColor = UIColor.white
        self.layer.shadowColor = UIColor.lightGray.cgColor;
        self.layer.shadowOffset = CGSize(width: 0, height: -3);
        self.layer.shadowOpacity = 0.1;
        
        YX_setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension YXPayBaseView {
    private func YX_setUpUI(){
        let view = UIView(frame: CGRect(x: YXScreenW - 168 - 15, y: 15, width: 168, height: 44))
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 168, height: 44)
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.locations = [0,1]
        gradientLayer.colors = [UIColor.YX_getColor(rgbValue: 0xFF657F).cgColor, UIColor.YX_getColor(rgbValue: 0xFF2B41).cgColor]
        view.layer.addSublayer(gradientLayer)
        view.clipsToBounds = true
        view.layer.cornerRadius = 22
        addSubview(view)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(YX_commitViewTap)))
        
        let commitOrderLabel = UILabel()
        commitOrderLabel.text = "提交订单"
        commitOrderLabel.textColor = UIColor.white
        commitOrderLabel.font = UIFont(name: "PingFang-SC-Medium", size: 17)
        view.addSubview(commitOrderLabel)
        commitOrderLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(view.snp_centerX)
            make.centerY.equalTo(view.snp_centerY)
        }
        
        let actualPaymentLabel = UILabel()
        actualPaymentLabel.text = "实付"
        actualPaymentLabel.textColor = UIColor.YX_getColor(rgbValue: 0x32312D)
        actualPaymentLabel.font = UIFont(name: "PingFang-SC-Regular", size: 18)
        actualPaymentLabel.textAlignment = .left
        addSubview(actualPaymentLabel)
        actualPaymentLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(view.snp_centerY)
            make.left.equalTo(snp_left).offset(15)
        }
        
        let moneySignLabel = UILabel()
        moneySignLabel.text = "¥"
        moneySignLabel.textColor = UIColor.YX_getColor(rgbValue: 0xFB3F52)
        moneySignLabel.font = UIFont(name: "PingFang-SC-Regular", size: 18)
        moneySignLabel.textAlignment = .left
        addSubview(moneySignLabel)
        moneySignLabel.snp.makeConstraints { (make) in
            make.left.equalTo(actualPaymentLabel.snp_right).offset(7)
            make.centerY.equalTo(actualPaymentLabel.snp_centerY)
        }
        
        addSubview(moneyLabel)
        moneyLabel.snp.makeConstraints { (make) in
            make.left.equalTo(moneySignLabel.snp_right)
            make.centerY.equalTo(moneySignLabel.snp_centerY)
        }
    }
}

extension YXPayBaseView {
    @objc private func YX_commitViewTap(){
        if commitOrderBlock != nil {
            commitOrderBlock!()
        }
    }
}
