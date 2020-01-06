//
//  YXAlreatView.swift
//  youxuan
//
//  Created by 肖锋 on 2019/10/23.
//  Copyright © 2019 肖锋. All rights reserved.
//

import UIKit

class YXAlreatView: UIView {
    
    private var sureBlock : (() -> ())?
    private var cancelBlock : (() -> ())?
    
    private lazy var titleLabel : UILabel = {
        let titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.YX_getColor(rgbValue: 0x4A4A4A)
        titleLabel.font = UIFont(name: "PingFang-SC-Regular", size: 16)
        return titleLabel
    }()
    
    private lazy var lineView : UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor.YX_getColor(rgbValue: 0xF2F2F2)
        return lineView
    }()
    
    private lazy var detailTitleLabel : UILabel = {
        let detailTitleLabel = UILabel()
        detailTitleLabel.textAlignment = .center
        detailTitleLabel.textColor = UIColor.YX_getColor(rgbValue: 0x4A4A4A)
        detailTitleLabel.font = UIFont(name: "PingFang-SC-Regular", size: 16)
        detailTitleLabel.numberOfLines = 0
        detailTitleLabel.isHidden = false
        return detailTitleLabel
    }()
    
    private lazy var textField : YXTextField = {
        let textField = YXTextField()
        textField.placeholder = "请输入提货码"
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.YX_getColor(rgbValue: 0xD8DBE3).cgColor;
        textField.clearButtonMode = .always;
        textField.keyboardType = .numberPad;
        textField.font = UIFont(name: "PingFang-SC-Regular", size: 15)
        textField.tintColor = UIColor.YX_getColor(rgbValue: 0xFB3F52)
        textField.textColor = UIColor.YX_getColor(rgbValue: 0xFB3F52)
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 44))
        textField.leftView = leftView
        textField.leftViewMode = .always;
        textField.isHidden = true
        return textField
    }()
    
    //确定按钮
    private lazy var sureBtn : YXLittleButtonView = {
        let sureBtn = YXLittleButtonView(frame: CGRect.zero, titleText: "确定") {
            if self.sureBlock != nil {
                self.sureBlock!()
            }
        }
        sureBtn.isHidden = true
        return sureBtn
    }()
    
    //取消按钮
    private lazy var cancelBtn : UIButton = {
        let cancelBtn = UIButton(type: UIButton.ButtonType.custom)
        cancelBtn.layer.borderColor = UIColor.YX_getColor(rgbValue: 0xFD5D6E).cgColor
        cancelBtn.layer.cornerRadius = 17
        cancelBtn.layer.borderWidth = 1
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.titleLabel?.font = UIFont(name: "PingFang-SC-Medium", size: 17)
        cancelBtn.setTitleColor(UIColor.YX_getColor(rgbValue: 0xFD5D6E), for: .normal)
        cancelBtn.addTarget(self, action: #selector(cancelBtnClick), for: .touchUpInside)
        cancelBtn.isHidden = true
        return cancelBtn
    }()
    
    /// 创建view
    /// - Parameter frame: view的frame
    /// - Parameter title: 主标题
    /// - Parameter detailTitle: 次标题
    /// - Parameter isTextOrTextFieldBool: 次标题是显示文本还是输入框(默认是文本)
    /// - Parameter isBtnCountBool: 按钮的个数(默认是两个)
    init(frame: CGRect, title: String, detailTitle: String, isTextOrTextFieldBool: Bool? = true, isBtnCountBool: Bool? = true, sureBtnTitle: String, sureBlock: @escaping () -> (), cancelBlock: @escaping () -> ()) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 5
        
        sureBtn.title.text = sureBtnTitle
        titleLabel.text = title
        detailTitleLabel.text = detailTitle
        
        self.sureBlock = sureBlock
        self.cancelBlock = cancelBlock
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top).offset(15)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.height.equalTo(0.5)
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
        }
        
        addSubview(detailTitleLabel)
        detailTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left).offset(15)
            make.right.equalTo(self.snp.right).offset(-15)
            make.top.equalTo(lineView.snp.bottom).offset(25)
        }
        
        addSubview(textField)
        textField.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left).offset(15)
            make.right.equalTo(self.snp.right).offset(-15)
            make.top.equalTo(lineView.snp.bottom).offset(25)
            make.height.equalTo(44)
        }
        
        addSubview(sureBtn)
        sureBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.centerX).offset(15)
            make.right.equalTo(self.snp.right).offset(-25)
            make.height.equalTo(34)
            make.bottom.equalTo(self.snp.bottom).offset(-25)
        }
        
        addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left).offset(25)
            make.height.equalTo(sureBtn.snp.height)
            make.right.equalTo(self.snp.centerX).offset(-15)
            make.bottom.equalTo(sureBtn.snp.bottom)
        }
        
        switch isTextOrTextFieldBool {
        case true:
            detailTitleLabel.isHidden = false
            textField.isHidden = true
        default:
            detailTitleLabel.isHidden = true
            textField.isHidden = false
        }
        
        switch isBtnCountBool {
        case true:
            sureBtn.isHidden = false
            cancelBtn.isHidden = false
        default:
            sureBtn.isHidden = false
            cancelBtn.isHidden = true
            sureBtn.snp.remakeConstraints { (make) in
                make.centerX.equalTo(self.snp.centerX)
                make.width.equalTo(118)
                make.height.equalTo(34)
                make.bottom.equalTo(self.snp.bottom).offset(-25)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension YXAlreatView {
    @objc private func cancelBtnClick(){
        if cancelBlock != nil {
            cancelBlock!()
        }
    }
}
