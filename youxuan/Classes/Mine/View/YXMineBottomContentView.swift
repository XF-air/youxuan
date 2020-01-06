//
//  YXMineBottomContentView.swift
//  youxuan
//
//  Created by 肖锋 on 2019/10/21.
//  Copyright © 2019 肖锋. All rights reserved.
//

import UIKit

class YXMineBottomContentView: UIView {
    
    private var tagInt : Int = 0
    
    private var clickBlock : ((Int) -> ())?
    
    private lazy var titleLabel : UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.YX_getColor(rgbValue: 0x4A4A4A)
        titleLabel.font = UIFont(name: "PingFang-SC-Regular", size: 15)
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    lazy var titleContentLabel : UILabel = {
        let titleContentLabel = UILabel()
        titleContentLabel.textColor = UIColor.YX_getColor(rgbValue: 0x4A4A4A)
        titleContentLabel.font = UIFont(name: "PingFang-SC-Medium", size: 18)
        titleContentLabel.textAlignment = .center
        return titleContentLabel
    }()
    
    lazy var circelView : UIView = {
        let circelView = UIView()
        circelView.backgroundColor = UIColor.red
        circelView.layer.cornerRadius = 3.5
        circelView.isHidden = true
        return circelView
    }()

    init(frame: CGRect, isNbBool: Bool, tag: Int, clickBlock: ((Int) -> ())?) {
        super.init(frame: frame)
        self.clickBlock = clickBlock
        self.YX_addContent(isNbBool: isNbBool)
        self.tagInt = tag
        let tap = UITapGestureRecognizer(target: self, action: #selector(YX_clickWithTag))
        addGestureRecognizer(tap)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension YXMineBottomContentView {
    private func YX_addContent(isNbBool: Bool) {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        addSubview(titleContentLabel)
        titleContentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(3)
            make.centerX.equalTo(titleLabel.snp.centerX)
        }
        
        addSubview(circelView)
        circelView.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top)
            make.width.height.equalTo(7)
            make.right.equalTo(titleLabel.snp.right).offset(3)
        }
        if isNbBool {
            titleLabel.text = "牛币"
            titleContentLabel.text = "0"
        }else {
            titleLabel.text = "提货核销"
            titleContentLabel.text = "\(0)个"
        }
    }
}
 
extension YXMineBottomContentView {
    @objc private func YX_clickWithTag() {
        if clickBlock != nil {
            clickBlock!(tagInt)
        }
    }
}
