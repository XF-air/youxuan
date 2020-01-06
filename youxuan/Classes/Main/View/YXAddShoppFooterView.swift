//
//  YXAddShoppFooterView.swift
//  youxuan
//
//  Created by 肖锋 on 2019/10/26.
//  Copyright © 2019 肖锋. All rights reserved.
//

import UIKit
import Kingfisher

private let YXPhotoW : CGFloat = (YXScreenW - 3 * 15) / 2

class YXAddShoppFooterView: UIView {
    
    
    var mineModel : YXMineModel?{
        didSet {
            businessLicenseView.chooseImageView.isUserInteractionEnabled = false
            businessLicenseView.deletaBtn.isHidden = true
            businessLicenseView.titleContentView.isHidden = true
            businessLicenseView.contentImageView.isHidden = true
            businessLicenseView.chooseImageView.isHidden = false
            
            doorPhotosView.chooseImageView.isUserInteractionEnabled = false
            doorPhotosView.deletaBtn.isHidden = true
            doorPhotosView.titleContentView.isHidden = true
            doorPhotosView.contentImageView.isHidden = true
            doorPhotosView.chooseImageView.isHidden = false
            
            businessLicenseView.chooseImageView.kf.setImage(with: URL(string: "\(pictureUrl)/\(mineModel!.businessLicense)"))
            doorPhotosView.chooseImageView.kf.setImage(with: URL(string: "\(pictureUrl)/\(mineModel!.shopFrontImg)"))
        }
    }
    
    
    var addShopBlock : ((Int) -> ())?
    var deleteBlock : ((Int) -> ())?
    
    private lazy var uploadShoppTitleLabel : UILabel = {
        let uploadShoppTitleLabel = UILabel()
        uploadShoppTitleLabel.text = "商铺信息上传"
        uploadShoppTitleLabel.textColor = UIColor.YX_getColor(rgbValue: 0x32312D)
        uploadShoppTitleLabel.font = UIFont(name: "PingFang-SC-Medium", size: 16)
        uploadShoppTitleLabel.textAlignment = .left
        return uploadShoppTitleLabel
    }()
    
    lazy var businessLicenseView : YXAddShoppPhotosBaseVeiw = { [unowned self] in
        let businessLicenseView = YXAddShoppPhotosBaseVeiw(frame: CGRect.zero, imageView: "login_img2", detailText: " 营业执照", deletaBlock: {
            if self.deleteBlock != nil {
                self.deleteBlock!(20000)
            }
            
        }) {
            if self.addShopBlock != nil {
                self.addShopBlock!(10000)
            }
        }
        return businessLicenseView
    }()
    
    lazy var doorPhotosView : YXAddShoppPhotosBaseVeiw = { [unowned self] in
        let doorPhotosView = YXAddShoppPhotosBaseVeiw(frame: CGRect.zero, imageView: "login_img1", detailText: " 门头照片", deletaBlock: {
            if self.deleteBlock != nil {
                self.deleteBlock!(20001)
            }
        }) {
            if self.addShopBlock != nil {
                self.addShopBlock!(10001)
            }
        }
        return doorPhotosView
    }()
    
    //添加闭包,用来设置在弹出之前进行是否有访问相册的权限
    init(frame: CGRect, addShopBlock: @escaping (Int) -> (), deleteBlock: @escaping (Int) -> ()) {
        super.init(frame: frame)
        self.addShopBlock = addShopBlock
        self.deleteBlock = deleteBlock
        backgroundColor = UIColor.white
        
        YX_setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension YXAddShoppFooterView {
    private func YX_setUI(){
        addSubview(uploadShoppTitleLabel)
        uploadShoppTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(snp.left).offset(15)
            make.top.equalTo(snp.top).offset(15)
        }
        
        addSubview(businessLicenseView)
        businessLicenseView.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp_left).offset(15)
            make.top.equalTo(uploadShoppTitleLabel.snp_bottom).offset(15)
            make.height.equalTo(138)
            make.width.equalTo(YXPhotoW)
        }
        
        addSubview(doorPhotosView)
        doorPhotosView.snp.makeConstraints { (make) in
            make.right.equalTo(self.snp_right).offset(-15)
            make.top.equalTo(businessLicenseView.snp_top)
            make.height.equalTo(businessLicenseView.snp_height)
            make.width.equalTo(businessLicenseView.snp_width)
        }
    }
}
