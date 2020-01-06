//
//  YXBasePayTableViewCell.swift
//  youxuan
//
//  Created by 肖锋 on 2019/11/25.
//  Copyright © 2019 肖锋. All rights reserved.
//

import UIKit

class YXBasePayTableViewCell: UITableViewCell {
    
    private lazy var titleImageView : UIImageView = {
        let titleImageView = UIImageView()
        return titleImageView
    }()
    
    private lazy var titleLabel : UILabel = {
        let titleLabel = UILabel()
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont(name: "PingFang-SC-Regular", size: 15)
        titleLabel.textColor = UIColor.YX_getColor(rgbValue: 0x4A4A4A)
        return titleLabel
    }()
    
    lazy var choosePayWayImageView : UIImageView = {
        let choosePayWayImageView = UIImageView(image: UIImage(named: "list_choicebox_nor"))
        return choosePayWayImageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.addSubview(titleImageView)
        titleImageView.snp.makeConstraints { (make) in
            make.left.equalTo(snp_left).offset(15)
            make.centerY.equalTo(snp_centerY)
            make.width.height.equalTo(24)
        }
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(snp_centerY)
            make.left.equalTo(titleImageView.snp_right).offset(5)
        }
        contentView.addSubview(choosePayWayImageView)
        choosePayWayImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(snp_centerY)
            make.width.height.equalTo(24)
            make.right.equalTo(snp_right).offset(-19)
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

extension YXBasePayTableViewCell {
    func YX_cellMessage(iconName: String, titleName: String) {
        titleImageView.image = UIImage(named: iconName)
        titleLabel.text = titleName
    }
}
