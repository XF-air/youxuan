//
//  YXProtocolView.swift
//  youxuan
//
//  Created by 肖锋 on 2019/10/15.
//  Copyright © 2019年 肖锋. All rights reserved.
//

import UIKit

class YXProtocolView: UIView {
    
    
    var clickProtocolBlock : (()->())?
    
    private lazy var contentView : UIView = {
        let contentView = UIView()
        return contentView
    }()
    
    private lazy var titleLabel : UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "未注册手机号，登录成功即默认同意"
        titleLabel.font = UIFont(name: "PingFang-SC-Regular", size: 12.0)
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .left
        return titleLabel
    }()
    
    private lazy var readProtocolBtn : UIButton = {
        let readProtocolBtn = UIButton(type: .custom)
        readProtocolBtn.setTitle("《牛滴优选服务条款》", for: .normal)
        readProtocolBtn.setTitleColor(UIColor.YX_getColor(rgbValue: 0xF39C13), for: .normal)
        readProtocolBtn.titleLabel?.font = UIFont(name: "PingFang-SC-Regular", size: 12.0)
        return readProtocolBtn
    }()
    
    init(frame: CGRect, clickProtocolBlock:@escaping ()->()) {
        super.init(frame: frame)
        self.clickProtocolBlock = clickProtocolBlock
        let tap = UITapGestureRecognizer(target: self, action: #selector(readProtocolBtnClick))
        self.addGestureRecognizer(tap)
        
        YX_addProtocolControl()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

//添加控件
extension YXProtocolView {
    private func YX_addProtocolControl(){
        addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.snp.bottom)
            make.height.equalTo(17.0)
            make.width.equalTo(self.bounds.width)
            make.top.equalTo(self.snp.top)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(contentView.snp.left)
            make.centerY.equalTo(contentView.snp.centerY)
        }
        contentView.addSubview(readProtocolBtn)
        readProtocolBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView.snp.centerY)
            make.left.equalTo(titleLabel.snp.right)
            make.height.equalTo(17.0)
            make.width.equalTo(120)
        }
    }
}

extension YXProtocolView {
    @objc private func readProtocolBtnClick() {
        if clickProtocolBlock != nil {
            clickProtocolBlock!()
        }
    }
}
