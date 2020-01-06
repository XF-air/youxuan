//
//  YXBaseCellContentView.swift
//  youxuan
//
//  Created by 肖锋 on 2019/10/23.
//  Copyright © 2019 肖锋. All rights reserved.
//

import UIKit

class YXBaseCellContentView: UIView {
    
    lazy var titleLabel : UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.YX_getColor(rgbValue: 0x32312D)
        titleLabel.font = UIFont(name: "PingFang-SC-Medium", size: 16)
        titleLabel.textAlignment = .left
        titleLabel.text = "商铺名:"
        return titleLabel
    }()
    
    lazy var textField : YXTextField = {
        let textField = YXTextField()
        textField.clearButtonMode = .whileEditing
        textField.layer.borderColor = UIColor.clear.cgColor;
        textField.textColor = UIColor.YX_getColor(rgbValue: 0x32312D)
        textField.tintColor = UIColor.YX_getColor(rgbValue: 0xC4C4C4)
        textField.font = UIFont(name: "PingFang-SC-Regular", size: 13.0)
        textField.backgroundColor = UIColor.white
        textField.delegate = self
        return textField
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        YX_setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//控件的添加
extension YXBaseCellContentView {
    private func YX_setUpUI(){
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left).offset(15)
            make.centerY.equalTo(self.snp.centerY)
            make.width.equalTo(80)
        }
        
        addSubview(textField)
        textField.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.right)
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.height.equalTo(20)
            make.right.equalTo(self.snp.right).offset(-15)
        }
    }
}

//输入框的代理
extension YXBaseCellContentView : UITextFieldDelegate {    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 10002 || textField.tag == 10003 {
            return false
        }
        return true
    }
}

