//
//  YXButtonView.swift
//  youxuan
//
//  Created by 肖锋 on 2019/10/16.
//  Copyright © 2019年 肖锋. All rights reserved.
//

import UIKit

class YXButtonView: UIView {
    
   private var clickBlock : (()->())?
    
   private lazy var contentView : UIView = {
        let contentView = UIView()
        contentView.frame = CGRect(x: 15, y: 15, width: YXScreenW - 30, height: 44)
        contentView.layer.cornerRadius = 22
        return contentView
    }()
    
    private lazy var title : UILabel = {
       let title = UILabel()
        title.font = UIFont(name: "PingFang-SC-Medium", size: 17)
        title.textAlignment = .center
        title.textColor = UIColor.white
        return title
    }()
    
    var textColorBool : Bool?{
        didSet{
            if textColorBool! {
                contentView.isUserInteractionEnabled = true
                YX_setUpLayer(fiestColor: 0xFF657F, secondColor: 0xFF2B41)
            }else {
                contentView.isUserInteractionEnabled = false
                YX_setUpLayer(fiestColor: 0xD8DBE3, secondColor: 0xD8DBE3)
            }
        }
    }
    
    init(frame: CGRect, titleText: String, isWhiteBool: Bool, clickBlock:@escaping () -> ()) {
        self.clickBlock = clickBlock
        super.init(frame: frame)
        if isWhiteBool {
            self.backgroundColor = UIColor.white
            self.layer.shadowColor = UIColor.lightGray.cgColor;
            self.layer.shadowOffset = CGSize(width: 0, height: -3);
            self.layer.shadowOpacity = 0.1;
        }
        
        addSubview(contentView)
        title.text = titleText
        
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(YX_btnClick))
        contentView.addGestureRecognizer(tap)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func YX_setUpLayer(fiestColor: UInt64, secondColor: UInt64){
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: YXScreenW - 30, height: 44)
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.locations = [0,1]
        gradientLayer.colors = [UIColor.YX_getColor(rgbValue: fiestColor).cgColor, UIColor.YX_getColor(rgbValue: secondColor).cgColor]//这里一定要使用cgColor转换,否则颜色是出不来的
        contentView.layer.addSublayer(gradientLayer)
        contentView.clipsToBounds = true
        contentView.addSubview(title)
        title.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView.snp.centerX)
            make.centerY.equalTo(contentView.snp.centerY)
        }
    }
    
    @objc private func YX_btnClick(){
        if clickBlock != nil {
            clickBlock!()
        }
    }
}
