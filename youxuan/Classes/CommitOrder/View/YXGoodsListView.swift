//
//  YXGoodsListView.swift
//  youxuan
//
//  Created by 肖锋 on 2019/11/20.
//  Copyright © 2019 肖锋. All rights reserved.
//

import UIKit

private let collectionViewID = "collectionViewID"
private let kItemMargin : CGFloat = 5
private let KItemSize : CGFloat = 81
class YXGoodsListView: UIView {
    
    var placeOrdersModel : YXPlaceOrdersModel?{
        didSet{
            guard let placeOrdersModel = placeOrdersModel else { return }
            imageView.kf.setImage(with: URL(string: "\(pictureUrl)/\(placeOrdersModel.image)"), placeholder: UIImage(named: "loading2"))
            nameLabel.text = placeOrdersModel.name
            goodsPriceContentLabel.text = placeOrdersModel.price
            switch placeOrdersModel.unitMeasure {
            case 1:
                goodsCompanyLabel.text = "/斤"
                countCompanyLabel.text = "X15斤"
                case 2:
                goodsCompanyLabel.text = "/箱"
                countCompanyLabel.text = "X15箱"
                case 3:
                goodsCompanyLabel.text = "/两"
                countCompanyLabel.text = "X15两"
                case 4:
                goodsCompanyLabel.text = "/盒"
                countCompanyLabel.text = "X15盒"
                case 5:
                goodsCompanyLabel.text = "/包"
                countCompanyLabel.text = "X15包"
                case 6:
                goodsCompanyLabel.text = "/件"
                countCompanyLabel.text = "X15件"
                case 7:
                goodsCompanyLabel.text = "/个"
                countCompanyLabel.text = "X15个"
            default:
                goodsCompanyLabel.text = "/串"
                countCompanyLabel.text = "X15串"
            }
        }
    }
    
    private lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: KItemSize, height: KItemSize)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: kItemMargin, bottom: 0, right: kItemMargin)
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: collectionViewID)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor.white
        collectionView.isHidden = true
        return collectionView
    }()
    
    private lazy var countLabel : UILabel = {
        let countLabel = UILabel()
        countLabel.text = "共4件"
        countLabel.font = UIFont(name: "PingFang-SC-Regular", size: 12)
        countLabel.textAlignment = .left
        countLabel.textColor = UIColor.YX_getColor(rgbValue: 0x4A4A4A)
        return countLabel
    }()
    
    private lazy var contentGoodsView : UIView = {
        let contentGoodsView = UIView()
        contentGoodsView.backgroundColor = UIColor.white
        return contentGoodsView
    }()
    
    private lazy var imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var nameLabel : UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont(name: "PingFang-SC-Semibold", size: 17)
        nameLabel.textAlignment = .left
        nameLabel.textColor = UIColor.YX_getColor(rgbValue: 0x4A4A4A)
        return nameLabel
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
        goodsCompanyLabel.textColor = UIColor.YX_getColor(rgbValue: 0xB4B4B4)
        goodsCompanyLabel.font = UIFont(name: "PingFang-SC-Regular", size: 12)
        goodsCompanyLabel.textAlignment = .left
        return goodsCompanyLabel
    }()
    
    private lazy var totalScalMoneyLabel : UILabel = {
        let totalScalMoneyLabel = UILabel()
        totalScalMoneyLabel.text = "¥00.0"
        totalScalMoneyLabel.textColor = UIColor.YX_getColor(rgbValue: 0xC4C4C4)
        totalScalMoneyLabel.font = UIFont(name: "PingFang-SC-Regular", size: 12)
        totalScalMoneyLabel.textAlignment = .left
        return totalScalMoneyLabel
    }()
    
    private lazy var lineView : UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor.YX_getColor(rgbValue: 0xC4C4C4)
        return lineView
    }()
    
    private lazy var countCompanyLabel : UILabel = {
       let countCompanyLabel = UILabel()
       countCompanyLabel.textColor = UIColor.YX_getColor(rgbValue: 0x9B9B9B)
       countCompanyLabel.font = UIFont(name: "PingFang-SC-Regular", size: 12)
       countCompanyLabel.textAlignment = .right
       return countCompanyLabel
    }()
    
    private var clickGoodsListBlock: (() -> ())?

    init(frame: CGRect, clickGoodsListBlock: (() -> ())?) {
        super.init(frame: frame)
        self.clickGoodsListBlock = clickGoodsListBlock
        YX_setUpUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension YXGoodsListView {
    private func YX_setUpUI(){
        let topLineView = UIView()
        topLineView.backgroundColor = UIColor.YX_getColor(rgbValue: 0xE1E1E1)
        addSubview(topLineView)
        topLineView.snp.makeConstraints { (make) in
            make.left.equalTo(snp_left).offset(10)
            make.height.equalTo(0.5)
            make.right.equalTo(snp_right)
            make.top.equalTo(snp_top)
        }
        
        let bottomLineView = UIView()
        bottomLineView.backgroundColor = UIColor.YX_getColor(rgbValue: 0xE1E1E1)
        addSubview(bottomLineView)
        bottomLineView.snp.makeConstraints { (make) in
            make.left.equalTo(snp_left)
            make.height.equalTo(0.5)
            make.right.equalTo(snp_right)
            make.bottom.equalTo(snp_bottom)
        }
        addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.left.equalTo(snp_left)
            make.right.equalTo(snp_right)
            make.top.equalTo(topLineView.snp_bottom)
            make.bottom.equalTo(bottomLineView.snp_top)
        }
        let rightView = UIView()
        rightView.backgroundColor = UIColor.yellow
        rightView.layer.shadowColor = UIColor.YX_getColor(rgbValue: 0xEFEFEF).cgColor
        rightView.layer.shadowOffset = CGSize(width: -2.5,height: 0)
        rightView.layer.shadowOpacity = 1
        rightView.layer.shadowRadius = 5.5
        rightView.isHidden = true
        rightView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(YX_seeMoreGoods)))
        addSubview(rightView)
        rightView.snp.makeConstraints { (make) in
            make.right.equalTo(snp_right)
            make.top.equalTo(topLineView.snp_bottom)
            make.bottom.equalTo(bottomLineView.snp_top)
            make.width.equalTo(60)
        }
        
        rightView.addSubview(countLabel)
        countLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(rightView.snp_centerX)
            make.centerY.equalTo(rightView.snp_centerY)
        }
        addSubview(contentGoodsView)
        contentGoodsView.snp.makeConstraints { (make) in
            make.left.equalTo(snp_left)
            make.right.equalTo(snp_right)
            make.top.equalTo(topLineView.snp_bottom)
            make.bottom.equalTo(bottomLineView.snp_top)
        }
        contentGoodsView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.left.equalTo(contentGoodsView.snp_left).offset(5)
            make.height.width.equalTo(81)
            make.centerY.equalTo(contentGoodsView.snp_centerY)
        }
        contentGoodsView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(imageView.snp_right).offset(10)
            make.top.equalTo(imageView.snp_top).offset(5)
        }
        
        contentGoodsView.addSubview(goodsPriceLabel)
        goodsPriceLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel.snp_left)
            make.bottom.equalTo(imageView.snp_bottom).offset(-3)
        }
        
        contentGoodsView.addSubview(goodsPriceContentLabel)
        goodsPriceContentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(goodsPriceLabel.snp_right)
            make.bottom.equalTo(imageView.snp_bottom)
        }
        
        contentGoodsView.addSubview(goodsCompanyLabel)
        goodsCompanyLabel.snp.makeConstraints { (make) in
            make.left.equalTo(goodsPriceContentLabel.snp_right)
            make.bottom.equalTo(goodsPriceLabel.snp_bottom)
        }
        
        contentGoodsView.addSubview(totalScalMoneyLabel)
        totalScalMoneyLabel.snp.makeConstraints { (make) in
            make.left.equalTo(goodsCompanyLabel.snp_right).offset(10)
            make.centerY.equalTo(goodsPriceContentLabel.snp_centerY)
        }
        totalScalMoneyLabel.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.left.equalTo(totalScalMoneyLabel.snp_left).offset(-3)
            make.centerY.equalTo(totalScalMoneyLabel.snp_centerY)
            make.right.equalTo(totalScalMoneyLabel.snp_right).offset(3)
            make.height.equalTo(1)
        }
        contentGoodsView.addSubview(countCompanyLabel)
        countCompanyLabel.snp.makeConstraints { (make) in
            make.right.equalTo(contentGoodsView.snp_right).offset(-10)
            make.centerY.equalTo(goodsPriceContentLabel.snp_centerY)
        }
    }
}


extension YXGoodsListView : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewID, for: indexPath)
        cell.backgroundColor = UIColor.YX_getRandomColor()
        return cell
    }
}

extension YXGoodsListView {
    @objc private func YX_seeMoreGoods(){
        if clickGoodsListBlock != nil {
            clickGoodsListBlock!()
        }
    }
}
