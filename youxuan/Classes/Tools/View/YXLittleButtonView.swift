//
//  YXLittleButtonView.swift
//  youxuan
//
//  Created by 肖锋 on 2019/10/23.
//  Copyright © 2019 肖锋. All rights reserved.
//

import UIKit

class YXLittleButtonView: UIView {

    private var clickBlock : (()->())?
     
    private lazy var contentView : UIView = {
         let contentView = UIView()
        contentView.frame = CGRect(x: 0, y: 0, width: (YXScreenW - 60)/2 - 40, height: 34)
         contentView.layer.cornerRadius = 17
         return contentView
     }()
     
    lazy var title : UILabel = {
        let title = UILabel()
         title.font = UIFont(name: "PingFang-SC-Medium", size: 17)
         title.textAlignment = .center
         title.textColor = UIColor.white
         return title
     }()
     
     init(frame: CGRect, titleText: String, clickBlock:@escaping () -> ()) {
         self.clickBlock = clickBlock
         super.init(frame: frame)
         addSubview(contentView)
         title.text = titleText
         
         let tap = UITapGestureRecognizer()
         tap.addTarget(self, action: #selector(YX_btnClick))
         contentView.addGestureRecognizer(tap)
        
        YX_setUpLayer(fiestColor: 0xFF657F, secondColor: 0xFF2B41)
     }
     
     required init?(coder aDecoder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
     
     private func YX_setUpLayer(fiestColor: UInt64, secondColor: UInt64){
         let gradientLayer = CAGradientLayer()
         gradientLayer.frame = CGRect(x: 0, y: 0, width: (YXScreenW - 60)/2 - 40, height: 34)
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
