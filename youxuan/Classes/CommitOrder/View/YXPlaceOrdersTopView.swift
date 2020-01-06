//
//  YXPlaceOrdersTopView.swift
//  youxuan
//
//  Created by 肖锋 on 2019/11/19.
//  Copyright © 2019 肖锋. All rights reserved.
//

import UIKit

class YXPlaceOrdersTopView: YXOrdersBaseView {
    
    var placeOrdersModel : YXPlaceOrdersModel?{
        didSet{
            guard let placeOrdersModel = placeOrdersModel else { return }
            addressContentLabel.text = placeOrdersModel.address
            nameLabel.text = placeOrdersModel.receivingName
            phoneNumberLabel.text = placeOrdersModel.phone
        }
    }
    
    private lazy var addressTitleLabel : UILabel = {
        let addressTitleLabel = UILabel()
        addressTitleLabel.text = "地址"
        addressTitleLabel.textColor = UIColor.YX_getColor(rgbValue: 0x6A88C2)
        addressTitleLabel.font = UIFont(name: "PingFang-SC-Light", size: 11)
        addressTitleLabel.layer.borderColor = UIColor.YX_getColor(rgbValue: 0x6A88C2).cgColor
        addressTitleLabel.layer.borderWidth = 0.5
        addressTitleLabel.layer.cornerRadius = 9
        addressTitleLabel.textAlignment = .center
        return addressTitleLabel
    }()
    
    private lazy var addressContentLabel : UILabel = {
        let addressContentLabel = UILabel()
        addressContentLabel.textAlignment = .left
        addressContentLabel.textColor = UIColor.YX_getColor(rgbValue: 0x32312D)
        addressContentLabel.font = UIFont(name: "PingFang-SC-Medium", size: 21)
        return addressContentLabel
    }()
    
    private lazy var arrowImageView : UIImageView = {
        let arrowImageView = UIImageView(image: UIImage(named: "icon_more1"))
        return arrowImageView
    }()
    
    private lazy var nameLabel : UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .left
        nameLabel.textColor = UIColor.YX_getColor(rgbValue: 0x9B9B9B)
        nameLabel.font = UIFont(name: "PingFang-SC-Light", size: 15)
        return nameLabel
    }()
    
    private lazy var phoneNumberLabel : UILabel = {
        let phoneNumberLabel = UILabel()
        phoneNumberLabel.textAlignment = .left
        phoneNumberLabel.textColor = UIColor.YX_getColor(rgbValue: 0x9B9B9B)
        phoneNumberLabel.font = UIFont(name: "PingFang-SC-Light", size: 15)
        return phoneNumberLabel
    }()
    
    private lazy var lineView : UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor.YX_getColor(rgbValue: 0xC4C4C4)
        return lineView
    }()
    
    private var chooseAddressBlock : (() -> ())?
    
    init(frame: CGRect, chooseAddressBlock : (() -> ())?) {
        super.init(frame: frame)
        self.chooseAddressBlock = chooseAddressBlock
        
        YX_setUpUI()
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(YX_chooseAddress)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension YXPlaceOrdersTopView {
    private func YX_setUpUI(){
        addSubview(addressTitleLabel)
        addressTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(snp_left).offset(10)
            make.top.equalTo(snp_top).offset(20.5)
            make.width.equalTo(32)
            make.height.equalTo(18)
        }
        addSubview(addressContentLabel)
        addressContentLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(addressTitleLabel.snp_centerY)
            make.left.equalTo(addressTitleLabel.snp_right).offset(5.5)
            make.right.equalTo(snp_right).offset(-44)
        }
        addSubview(arrowImageView)
        arrowImageView.snp.makeConstraints { (make) in
            make.right.equalTo(snp_right).offset(-10)
            make.height.width.equalTo(24)
            make.centerY.equalTo(addressTitleLabel.snp_centerY)
        }
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(addressTitleLabel.snp_left)
            make.bottom.equalTo(snp_bottom).offset(-15)
        }
        addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.centerY.equalTo(nameLabel.snp_centerY)
            make.left.equalTo(nameLabel.snp_right).offset(10)
            make.width.equalTo(0.5)
            make.height.equalTo(10)
        }
        addSubview(phoneNumberLabel)
        phoneNumberLabel.snp.makeConstraints { (make) in
            make.left.equalTo(lineView.snp_right).offset(10)
            make.centerY.equalTo(nameLabel.snp_centerY)
        }
    }
}

extension YXPlaceOrdersTopView {
    @objc private func YX_chooseAddress(){
        if chooseAddressBlock != nil {
            chooseAddressBlock!()
        }
    }
}
