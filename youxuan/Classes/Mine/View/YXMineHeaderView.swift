//
//  YXMineHeaderView.swift
//  youxuan
//
//  Created by 肖锋 on 2019/10/21.
//  Copyright © 2019 肖锋. All rights reserved.
//

import UIKit

//nb的别名
typealias nbBlock = (() -> ())?
class YXMineHeaderView: UIView {
    
    var mineModel : YXMineModel?{
        didSet{
           guard let mineModel = mineModel else { return }
            puMineBottomContentView.titleContentLabel.text = "\(mineModel.orderCount)个"
            userTitleLabel.text = "\(mineModel.mobile.count == 0 ? "请登录" : mineModel.mobile)"
            nbMineBottomContentView.titleContentLabel.text = "\(mineModel.balance)"
            mineModel.orderCount == 0 ? (puMineBottomContentView.circelView.isHidden = true) : (puMineBottomContentView.circelView.isHidden = false)
            YXUserDefulatTools.YX_getUserDefult() == nil ? (loginOutBtn.isHidden = true) : (loginOutBtn.isHidden = false)
        }
    }
    
    private var jumpLoginBlock : (() -> ())?
    
    //定义闭包退出登录
    private var loginOutBlock : (() -> ())?
    
    private var nbBlock : (() -> ())?
    
    //定义闭包提货核销
    private var pickUpGoodsBlock : (() -> ())?
    
    var allBtnBlock : ((Int) -> ())?
    
    private lazy var minebackImageView : UIImageView = {
        let minebackImageView = UIImageView(image: UIImage(named: "mine_bg"))
        minebackImageView.isUserInteractionEnabled = true
        return minebackImageView
    }()
    
    private lazy var bottomContentView : YXShadowBaseView = {
        let bottomContentView = YXShadowBaseView(frame: CGRect.zero, shadowColor: UIColor.clear, shadowSize: CGSize(width: 0, height: 7), shadowRadius: 15, cornerRadius: 15)
        return bottomContentView
    }()
    
    private lazy var lineView : UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor.YX_getColor(rgbValue: 0xC4C4C4)
        return lineView
    }()
    
    private lazy var nbMineBottomContentView : YXMineBottomContentView = { [unowned self] in
        let nbMineBottomContentView = YXMineBottomContentView(frame: CGRect.zero, isNbBool: true, tag: 10000) { (tag) in
            print("nbtag值:\(tag)")
            self.YX_pushNbDetail(tag: tag)
        }
        return nbMineBottomContentView
    }()
    
    private lazy var puMineBottomContentView : YXMineBottomContentView = { [unowned self] in
        let nbMineBottomContentView = YXMineBottomContentView(frame: CGRect.zero, isNbBool: false, tag: 10001) { (tag) in
            print("putag值:\(tag)")
            self.YX_pushNbDetail(tag: tag)
        }
        return nbMineBottomContentView
    }()
    
    private  lazy var userImageView : UIImageView = {
        let userImageView = UIImageView(image: UIImage(named: "mine_avatar"))
        userImageView.layer.cornerRadius = 25
        return userImageView
    }()
    
    private lazy var userTitleLabel : UILabel = {
        let userTitleLabel = UILabel()
        userTitleLabel.textColor = UIColor.white
        userTitleLabel.font = UIFont(name: "PingFang-SC-Semibold", size: 17)
        userTitleLabel.isUserInteractionEnabled = true
        userTitleLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(YX_jumpLogin)))
        return userTitleLabel
    }()
    
    private lazy var myOrderTitleLabel : UILabel = {
        let myOrderTitleLabel = UILabel()
        myOrderTitleLabel.text = "我的订单"
        myOrderTitleLabel.textAlignment = .left
        myOrderTitleLabel.font = UIFont(name: "PingFang-SC-Medium", size: 18)
        myOrderTitleLabel.textColor = UIColor.YX_getColor(rgbValue: 0x4A4A4A)
        return myOrderTitleLabel
    }()
    
    private lazy var loginOutBtn : UIButton = {
        let loginOutBtn = UIButton(type: .custom)
        loginOutBtn.setTitle("退出登录", for: .normal)
        loginOutBtn.layer.cornerRadius = 14
        loginOutBtn.layer.borderColor = UIColor.white.cgColor
        loginOutBtn.layer.borderWidth = 0.5
        loginOutBtn.backgroundColor = UIColor.clear
        loginOutBtn.titleLabel?.font = UIFont(name: "PingFang-SC-Regular", size: 13)
        loginOutBtn.addTarget(self, action: #selector(YX_loginOut), for: .touchUpInside)
        loginOutBtn.isHidden = true
        return loginOutBtn
    }()
    
    private lazy var allBtn : UIButton = {
        let allBtn = UIButton(type: .custom)
        allBtn.setTitle("全部", for: .normal)
        allBtn.titleLabel?.font = UIFont(name: "PingFang-SC-Medium", size: 13)
        allBtn.setTitleColor(UIColor.YX_getColor(rgbValue: 0xCFD5E5), for: .normal)
        allBtn.addTarget(self, action: #selector(YX_allBtn), for: .touchUpInside)
        allBtn.layer.borderColor = UIColor.YX_getColor(rgbValue: 0xCFD5E5).cgColor
        allBtn.layer.borderWidth = 1
        allBtn.layer.cornerRadius = 13
        return allBtn
    }()
    
    init(frame: CGRect, loginOutBlock: (() -> ())?, nbBlock: nbBlock, pickUpGoodsBlock: (() -> ())?, jumpLoginBlock: (() -> ())?) {
        super.init(frame: frame)
        self.loginOutBlock = loginOutBlock
        self.nbBlock = nbBlock
        self.pickUpGoodsBlock = pickUpGoodsBlock
        self.jumpLoginBlock = jumpLoginBlock
        
        backgroundColor = UIColor.YX_getColor(rgbValue: 0xFAFAFA)
        
        YX_addControl()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension YXMineHeaderView {
    private func YX_addControl(){
        addSubview(minebackImageView)
        minebackImageView.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
            make.top.equalTo(self.snp.top)
            make.height.equalTo(195.5)
        }
        
        minebackImageView.addSubview(userImageView)
        userImageView.snp.makeConstraints { (make) in
            make.left.equalTo(minebackImageView.snp.left).offset(15)
            make.height.width.equalTo(50)
            make.top.equalTo(minebackImageView.snp.top).offset(50)
        }
        minebackImageView.addSubview(userTitleLabel)
        userTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(userImageView.snp.right).offset(10)
            make.centerY.equalTo(userImageView.snp.centerY)
        }
        minebackImageView.addSubview(loginOutBtn)
        loginOutBtn.snp.makeConstraints { (make) in
            make.right.equalTo(minebackImageView.snp.right).offset(-15)
            make.height.equalTo(28)
            make.width.equalTo(73)
            make.centerY.equalTo(userImageView.snp.centerY)
        }
        addSubview(bottomContentView)
        bottomContentView.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left).offset(10)
            make.right.equalTo(self.snp.right).offset(-10)
            make.height.equalTo(140)
            make.top.equalTo(self.snp.top).offset(130)
        }
        bottomContentView.addSubview(myOrderTitleLabel)
        myOrderTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(bottomContentView.snp.left).offset(15);
            make.top.equalTo(bottomContentView.snp.top).offset(15)
        }
        bottomContentView.addSubview(allBtn)
        allBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(myOrderTitleLabel.snp.centerY);
            make.width.equalTo(50)
            make.height.equalTo(26)
            make.right.equalTo(-15)
        }
//        bottomContentView.addSubview(lineView)
//        lineView.snp.makeConstraints { (make) in
//            make.centerY.equalTo(bottomContentView.snp.centerY)
//            make.height.equalTo(20)
//            make.width.equalTo(1)
//            make.centerX.equalTo(bottomContentView.snp.centerX)
//        }
        
//        bottomContentView.addSubview(nbMineBottomContentView)
//        nbMineBottomContentView.snp.makeConstraints { (make) in
//            make.left.equalTo(bottomContentView.snp.left);
//            make.right.equalTo(lineView.snp.left)
//            make.centerY.equalTo(bottomContentView.snp.centerY)
//            make.height.equalTo(49)
//        }
//
//        bottomContentView.addSubview(puMineBottomContentView)
//        puMineBottomContentView.snp.makeConstraints { (make) in
//            make.left.equalTo(lineView.snp.right)
//            make.right.equalTo(bottomContentView.snp.right)
//            make.centerY.equalTo(nbMineBottomContentView.snp.centerY)
//            make.height.equalTo(nbMineBottomContentView.snp.height)
//        }
    }
}

extension YXMineHeaderView {
    private func YX_pushNbDetail(tag: Int) {
        switch tag {
        case 10000:
            if nbBlock != nil {
                nbBlock!()
            }
        default:
            if pickUpGoodsBlock != nil{
                pickUpGoodsBlock!()
            }
        }
    }
    
    @objc private func YX_loginOut(){
        print("退出登录")
        if loginOutBlock != nil {
            loginOutBlock!()
        }
    }
    
    @objc private func YX_jumpLogin(){
        if jumpLoginBlock != nil {
            jumpLoginBlock!()
        }
    }
    
    @objc private func YX_allBtn(){
        if allBtnBlock != nil {
            allBtnBlock!(10000)
        }
    }
}
