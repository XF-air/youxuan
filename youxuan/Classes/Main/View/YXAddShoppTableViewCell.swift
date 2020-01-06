//
//  YXAddShoppTableViewCell.swift
//  youxuan
//
//  Created by 肖锋 on 2019/10/23.
//  Copyright © 2019 肖锋. All rights reserved.
//

import UIKit
enum YX_keyboardType {
    case defaultKey
    case numberPadKey
}

class YXAddShoppTableViewCell: UITableViewCell {
    
    var areaLabelBlock : (() -> ())?
    
    //名字
    var titleName : String!{
        didSet{
            baseCellContentView.titleLabel.text = titleName
        }
    }
    
    //占位文字内容
    var placeholder : String!{
        didSet{
            baseCellContentView.textField.placeholder = placeholder
        }
    }
    
    //给每个文本赋tag值
    var textTag : Int!{
        didSet{
            baseCellContentView.textField.tag = textTag
        }
    }
    
    //给键盘赋值
    var keyboardType : YX_keyboardType!{
        didSet{
            switch keyboardType {
            case .numberPadKey?:
                baseCellContentView.textField.keyboardType = .numberPad
            default:
                baseCellContentView.textField.keyboardType = .default
            }
        }
    }
    
    //给输入框的手机号赋值
    var phoneNumber : String!{
        didSet{
            baseCellContentView.textField.text = phoneNumber
        }
    }
    
    //给areaLabel赋值
    var areaLabelText : String!{
        didSet{
            areaLabel.text = areaLabelText
            areaLabel.textColor = UIColor.YX_getColor(rgbValue: 0x32312D)
        }
    }
    
    //添加选择省市区的控件
    lazy var areaLabel : UILabel = {
        let areaLabel = UILabel()
        areaLabel.text = "请选择省市区"
        areaLabel.textColor = UIColor.YX_getColor(rgbValue: 0xC4C4C4)
        areaLabel.font = UIFont(name: "PingFang-SC-Regular", size: 13)
        areaLabel.textAlignment = .left
        areaLabel.isUserInteractionEnabled = true
        areaLabel.isHidden = true
        areaLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(YX_areaLabelTap)))
        return areaLabel
    }()
    
    lazy var baseCellContentView : YXBaseCellContentView = {
        let baseCellContentView = YXBaseCellContentView()
        return baseCellContentView
    }()
    
    lazy var arrorImageView : UIImageView = {
        let arrorImageView = UIImageView(image: UIImage(named: "icon_more1"))
        arrorImageView.isHidden = true
        return arrorImageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        YX_setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//添加UI
extension YXAddShoppTableViewCell {
    private func YX_setUpUI(){
        contentView.addSubview(baseCellContentView)
        baseCellContentView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top)
            make.left.equalTo(contentView.snp.left)
            make.right.equalTo(contentView.snp.right).offset(-45)
            make.bottom.equalTo(contentView.snp.bottom).offset(-5)
        }
        
        contentView.addSubview(arrorImageView)
        arrorImageView.snp.makeConstraints { (make) in
            make.right.equalTo(contentView.snp.right).offset(-15)
            make.centerY.equalTo(baseCellContentView.snp.centerY)
            make.height.width.equalTo(24)
        }
        baseCellContentView.addSubview(areaLabel)
        areaLabel.snp.makeConstraints { (make) in
            make.left.equalTo(baseCellContentView.titleLabel.snp_right)
            make.right.equalTo(baseCellContentView.snp_right).offset(-15)
            make.centerY.equalTo(baseCellContentView.snp_centerY)
        }
        
    }
}

//label的监听
extension YXAddShoppTableViewCell {
    @objc private func YX_areaLabelTap(){
        if areaLabelBlock != nil {
            areaLabelBlock!()
        }
    }
}
