//
//  YXAddShoppPhotosBaseVeiw.swift
//  youxuan
//
//  Created by 肖锋 on 2019/10/27.
//  Copyright © 2019 肖锋. All rights reserved.
//

import UIKit

class YXAddShoppPhotosBaseVeiw: UIView {
    
    //删除按钮的闭包
    private var deletaBlock : (() -> ())?
    
    //选择照相机
    private var chooseCameraBlock : (() -> ())?
    
    private lazy var photoContentView : UIView = {
        let photoContentView = UIView()
        photoContentView.backgroundColor = UIColor.white
        return photoContentView
    }()
    
    private lazy var contentView : UIView = {
        let contentView = UIView()
        contentView.backgroundColor = UIColor .white
        return contentView
    }()
    
    lazy var contentImageView : UIImageView = {
        let contentImageView = UIImageView()
        contentImageView.isUserInteractionEnabled = true
        contentImageView.contentMode = .scaleAspectFill
        return contentImageView
    }()
    
    lazy var chooseImageView : UIImageView = {
        let chooseImageView = UIImageView()
        chooseImageView.layer.cornerRadius = 3
        chooseImageView.contentMode = .scaleAspectFill
        chooseImageView.clipsToBounds = true
        chooseImageView.backgroundColor = UIColor.white
        chooseImageView.isHidden = true
        chooseImageView.isUserInteractionEnabled = true
        return chooseImageView
    }()
    
    lazy var deletaBtn : UIButton = {
        let deletaBtn = UIButton(type: UIButton.ButtonType.custom)
        deletaBtn.setImage(UIImage(named: "icon／close3"), for: .normal)
        deletaBtn.isHidden = true
        deletaBtn.addTarget(self, action: #selector(YX_deletaBtnClick), for: .touchUpInside)
        return deletaBtn
    }()
    
    lazy var titleContentView : UIView = {
        let titleContentView = UIView()
        titleContentView.backgroundColor = UIColor.white
        return titleContentView
    }()
    
    private lazy var titleLabel : UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "点击上传"
        titleLabel.font = UIFont(name: "PingFang-SC-Regular", size: 13)
        titleLabel.textColor = UIColor.YX_getColor(rgbValue: 0x9B9B9B)
        titleLabel.textAlignment = .left
        return titleLabel
    }()
    
    private lazy var detailLabel : UILabel = {
        let detailLabel = UILabel()
        detailLabel.font = UIFont(name: "PingFang-SC-Regular", size: 13)
        detailLabel.textColor = UIColor.YX_getColor(rgbValue: 0xFB3F52)
        detailLabel.textAlignment = .left
        return detailLabel
    }()

    init(frame: CGRect, imageView: String, detailText: String, deletaBlock: @escaping () -> (), chooseCameraBlock: @escaping () -> ()) {
        super.init(frame: frame)
        
        self.deletaBlock = deletaBlock
        self.chooseCameraBlock = chooseCameraBlock
        
        //设置阴影
        backgroundColor = UIColor.white
        layer.shadowColor = UIColor.YX_getColor(rgbValue: 0xCFD5E5, alpha: 0.3).cgColor
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowOpacity = 1
        layer.shadowRadius = 15
        
        YX_setUpUI()
        
        YX_setContentUI(imageView: imageView, detailText: detailText)
        
        contentImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(YX_tapContentImageView)))
        chooseImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(YX_tapContentImageView)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//添加控件
extension YXAddShoppPhotosBaseVeiw {
    private func YX_setUpUI(){
        addSubview(photoContentView)
        photoContentView.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left).offset(15)
            make.right.equalTo(self.snp_right).offset(-10)
            make.bottom.equalTo(self.snp_bottom).offset(-15)
            make.top.equalTo(self.snp_top).offset(15)
        }
        
        photoContentView.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.left.equalTo(photoContentView.snp_left).offset(5)
            make.right.equalTo(photoContentView.snp_right).offset(-5)
            make.top.equalTo(photoContentView.snp_top).offset(5)
            make.bottom.equalTo(photoContentView.snp_bottom).offset(-5)
        }
        
        contentView.addSubview(chooseImageView)
        chooseImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView.snp_edges)
        }
    
        contentView.addSubview(contentImageView)
        contentImageView.snp.makeConstraints { (make) in
            make.left.equalTo(contentView.snp_left)
            make.right.equalTo(contentView.snp_right)
            make.top.equalTo(contentView.snp_top).offset(5)
            make.height.equalTo(143/2)
        }
        contentView.addSubview(titleContentView)
        titleContentView.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView.snp_centerX)
            make.bottom.equalTo(contentView.snp_bottom).offset(10)
            make.width.equalTo(108.5)
            make.height.equalTo(18.5)
        }
        
        titleContentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleContentView.snp_left)
            make.centerY.equalTo(titleContentView.snp_centerY)
        }
        
        titleContentView.addSubview(detailLabel)
        detailLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp_right)
            make.centerY.equalTo(titleContentView.snp_centerY)
        }

        photoContentView.addSubview(deletaBtn)
        deletaBtn.snp.makeConstraints { (make) in
            make.top.equalTo(photoContentView.snp_top).offset(-2)
            make.right.equalTo(photoContentView.snp_right).offset(2)
            make.height.width.equalTo(18)
        }
    }
}

//给控件赋值
extension YXAddShoppPhotosBaseVeiw {
    private func YX_setContentUI(imageView: String, detailText: String){
        contentImageView.image = UIImage(named: imageView)
        detailLabel.text = detailText
    }
}

//方法的监听
extension YXAddShoppPhotosBaseVeiw {
    @objc private func YX_deletaBtnClick(){
        if deletaBlock != nil{
            deletaBlock!()
        }
    }
    
    @objc private func YX_tapContentImageView(){
        if chooseCameraBlock != nil {
            chooseCameraBlock!()
        }
    }
}
