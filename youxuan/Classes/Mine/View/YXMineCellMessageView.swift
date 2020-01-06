//
//  YXMineCellMessageView.swift
//  youxuan
//
//  Created by 肖锋 on 2019/10/21.
//  Copyright © 2019 肖锋. All rights reserved.
//

import UIKit

class YXMineCellMessageView: UIView {
    
    lazy var titleImageView : UIImageView = {
        let titleImageView = UIImageView(image: UIImage(named: "icon_store"))
        return titleImageView
    }()
    
    lazy var titleLabel : UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.YX_getColor(rgbValue: 0x32312D)
        titleLabel.font = UIFont(name: "PingFang-SC-Medium", size: 16)
        titleLabel.textAlignment = .left
        titleLabel.text = "商铺信息"
        return titleLabel
    }()
    
    private lazy var arrowImageView : UIImageView = {
        let arrowImageView = UIImageView(image: UIImage(named: "icon_more1"))
        return arrowImageView
    }()
    
    private var tapClickBlock : ((Int) -> ())?

    init(frame: CGRect, tapClickBlock: ((Int) -> ())?) {
        super.init(frame: frame)
        self.tapClickBlock = tapClickBlock
        self.YX_setUpUI()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(YX_tap))
        self.addGestureRecognizer(tap)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension YXMineCellMessageView {
    private func YX_setUpUI() {
        addSubview(titleImageView)
        titleImageView.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left).offset(15)
            make.width.height.equalTo(24)
            make.centerY.equalTo(self.snp.centerY)
        }
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleImageView.snp.right).offset(10)
            make.centerY.equalTo(titleImageView.snp.centerY)
        }
        addSubview(arrowImageView)
        arrowImageView.snp.makeConstraints { (make) in
            make.right.equalTo(self.snp.right).offset(-10)
            make.width.height.equalTo(24)
            make.centerY.equalTo(titleImageView.snp.centerY)
        }
    }
}

extension YXMineCellMessageView {
    @objc private func YX_tap(){
        if tapClickBlock != nil {
            tapClickBlock!(self.tag)
        }
    }
}
