//
//  YXAddressTableViewCell.swift
//  youxuan
//
//  Created by 肖锋 on 2019/11/27.
//  Copyright © 2019 肖锋. All rights reserved.
//

import UIKit

class YXAddressTableViewCell: UITableViewCell {
    
    private lazy var titleLabel : UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "望江国际 22楼520室"
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont(name: "PingFang-SC-Medium", size: 16)
        titleLabel.textColor = UIColor.YX_getColor(rgbValue: 0x32312D)
        return titleLabel
    }()
    
    private lazy var nameLabel : UILabel = {
        let nameLabel = UILabel()
        nameLabel.text = "佐木(先生)"
        nameLabel.textColor = UIColor.YX_getColor(rgbValue: 0xC4C4C4)
        nameLabel.font = UIFont(name: "PingFang-SC-Regular", size: 15)
        nameLabel.textAlignment = .left
        return nameLabel
    }()
    
    private lazy var lineView : UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor.YX_getColor(rgbValue: 0xC4C4C4)
        return lineView
    }()
    
    private lazy var phoneLabel : UILabel = {
        let phoneLabel = UILabel()
        phoneLabel.text = "18815070493"
        phoneLabel.textColor = UIColor.YX_getColor(rgbValue: 0xC4C4C4)
        phoneLabel.font = UIFont(name: "PingFang-SC-Regular", size: 15)
        phoneLabel.textAlignment = .left
        return phoneLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(contentView.snp_left).offset(15)
            make.top.equalTo(contentView.snp_top).offset(15)
        }
        
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp_left)
            make.bottom.equalTo(contentView.snp_bottom).offset(-14.5)
        }
        
        contentView.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel.snp_right).offset(10)
            make.height.equalTo(10)
            make.width.equalTo(0.5)
            make.centerY.equalTo(nameLabel.snp_centerY)
        }
        
        contentView.addSubview(phoneLabel)
        phoneLabel.snp.makeConstraints { (make) in
            make.left.equalTo(lineView.snp_right).offset(10)
            make.centerY.equalTo(lineView.snp_centerY)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
