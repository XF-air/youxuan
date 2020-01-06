//
//  YXHomeTableViewCell.swift
//  youxuan
//
//  Created by 肖锋 on 2019/11/8.
//  Copyright © 2019 肖锋. All rights reserved.
//

import UIKit

class YXHomeTableViewCell: UITableViewCell {
    
    var bgButtonClicked : (() -> ())?
    
    var homeGoodsModel : YXGoodsModel?{
        didSet{
            guard let homeGoodsModel = homeGoodsModel else { return }
            goodsTitleLabel.text = homeGoodsModel.name
            goodsDetailLabel.text = homeGoodsModel.intro
            goodsImageView.kf.setImage(with: URL(string: "\(pictureUrl)/\(homeGoodsModel.image)"), placeholder: UIImage(named: "loading2"))
            goodsPriceContentLabel.text = homeGoodsModel.price
            switch homeGoodsModel.unitMeasure {
            case 1:
                goodsCompanyLabel.text = "/斤"
                case 2:
                goodsCompanyLabel.text = "/箱"
                case 3:
                goodsCompanyLabel.text = "/两"
                case 4:
                goodsCompanyLabel.text = "/盒"
                case 5:
                goodsCompanyLabel.text = "/包"
                case 6:
                goodsCompanyLabel.text = "/件"
                case 7:
                goodsCompanyLabel.text = "/个"
            default:
                goodsCompanyLabel.text = "/串"
            }
        }
    }
    
    private lazy var cellContentView : UIView = {
        let cellContentView = UIView()
        cellContentView.backgroundColor = UIColor.white
        return cellContentView
    }()
    
    private lazy var goodsImageView : UIImageView = {
        let goodsImageView = UIImageView()
        goodsImageView.backgroundColor = UIColor.white
        goodsImageView.contentMode = .scaleAspectFill
        goodsImageView.clipsToBounds = true
        return goodsImageView
    }()
    
    private lazy var goodsTitleLabel : UILabel = {
        let goodsTitleLabel = UILabel()
        goodsTitleLabel.textColor = UIColor.YX_getColor(rgbValue: 0x4A4A4A)
        goodsTitleLabel.font = UIFont(name: "PingFang-SC-Semibold", size: 17)
        goodsTitleLabel.textAlignment = .left
        return goodsTitleLabel
    }()
    
    private lazy var goodsDetailLabel : UILabel = {
        let goodsDetailLabel = UILabel()
        goodsDetailLabel.textColor = UIColor.YX_getColor(rgbValue: 0x9B9B9B)
        goodsDetailLabel.font = UIFont(name: "PingFang-SC-Regular", size: 11)
        goodsDetailLabel.textAlignment = .left
        return goodsDetailLabel
    }()
    
    private lazy var goodsPriceLabel : UILabel = {
        let goodsPriceLabel = UILabel()
        goodsPriceLabel.text = "¥"
        goodsPriceLabel.textColor = UIColor.YX_getColor(rgbValue: 0xFD5D6E)
        goodsPriceLabel.font = UIFont(name: "PingFang-SC-Medium", size: 12)
        goodsPriceLabel.textAlignment = .left
        return goodsPriceLabel
    }()
    
    private lazy var goodsPriceContentLabel : UILabel = {
        let goodsPriceContentLabel = UILabel()
        goodsPriceContentLabel.textColor = UIColor.YX_getColor(rgbValue: 0xFD5D6E)
        goodsPriceContentLabel.font = UIFont(name: "PingFang-SC-Medium", size: 18)
        goodsPriceContentLabel.textAlignment = .left
        return goodsPriceContentLabel
    }()
    
    private lazy var goodsCompanyLabel : UILabel = {
        let goodsCompanyLabel = UILabel()
        goodsCompanyLabel.textColor = UIColor.YX_getColor(rgbValue: 0xFD5D6E)
        goodsCompanyLabel.font = UIFont(name: "PingFang-SC-Regular", size: 12)
        goodsCompanyLabel.textAlignment = .left
        return goodsCompanyLabel
    }()
    
    private lazy var grabAtOnceView : YXGrabAtOnceView = {
        let grabAtOnceView = YXGrabAtOnceView(frame: CGRect.zero) { [unowned self] in
            if self.bgButtonClicked != nil {
                self.bgButtonClicked!()
            }
        }
        return grabAtOnceView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.white
        
        YX_setUpUI()
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
//添加控件
extension YXHomeTableViewCell {
    private func YX_setUpUI(){
        contentView.addSubview(cellContentView)
        cellContentView.snp.makeConstraints { (make) in
            make.left.equalTo(contentView.snp_left)
            make.right.equalTo(contentView.snp_right)
            make.bottom.equalTo(contentView.snp_bottom).offset(-5)
            make.top.equalTo(contentView.snp_top)
        }
        
        cellContentView.addSubview(goodsImageView)
        goodsImageView.snp.makeConstraints { (make) in
            make.left.equalTo(cellContentView.snp_left).offset(5)
            make.height.width.equalTo(81)
            make.centerY.equalTo(cellContentView.snp_centerY)
        }
        
        cellContentView.addSubview(goodsTitleLabel)
        goodsTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(goodsImageView.snp_right).offset(10)
            make.top.equalTo(goodsImageView.snp_top).offset(3)
        }
        
        cellContentView.addSubview(goodsDetailLabel)
        goodsDetailLabel.snp.makeConstraints { (make) in
            make.left.equalTo(goodsTitleLabel.snp_left)
            make.top.equalTo(goodsTitleLabel.snp_bottom).offset(3)
        }
        
        cellContentView.addSubview(goodsPriceLabel)
        goodsPriceLabel.snp.makeConstraints { (make) in
            make.left.equalTo(goodsTitleLabel.snp_left)
            make.bottom.equalTo(goodsImageView.snp_bottom).offset(-3)
        }
        
        cellContentView.addSubview(goodsPriceContentLabel)
        goodsPriceContentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(goodsPriceLabel.snp_right)
            make.bottom.equalTo(goodsImageView.snp_bottom)
        }
        
        cellContentView.addSubview(goodsCompanyLabel)
        goodsCompanyLabel.snp.makeConstraints { (make) in
            make.left.equalTo(goodsPriceContentLabel.snp_right)
            make.bottom.equalTo(goodsPriceLabel.snp_bottom)
        }
        
        cellContentView.addSubview(grabAtOnceView)
        grabAtOnceView.snp.makeConstraints { (make) in
            make.right.equalTo(cellContentView.snp_right).offset(-10)
            make.bottom.equalTo(cellContentView.snp_bottom).offset(-10)
            make.height.equalTo(28)
            make.width.equalTo(65.5)
        }
    }
}
