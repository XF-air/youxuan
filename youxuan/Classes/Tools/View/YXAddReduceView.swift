//
//  YXAddReduceView.swift
//  youxuan
//
//  Created by 肖锋 on 2019/11/13.
//  Copyright © 2019 肖锋. All rights reserved.
//

import UIKit

class YXAddReduceView: UIView {
    
    var clickBlock: (() -> ())?
    
    
    //横线
    private lazy var mHorizontalLineView : UIView = {
        let mHorizontalLineView = UIView()
        //设置默认颜色
        mHorizontalLineView.backgroundColor = UIColor.YX_getColor(rgbValue: 0x999999)
        mHorizontalLineView.layer.cornerRadius = 1
        return mHorizontalLineView
    }()
    
    private lazy var addHorizontalLineView : UIView = {
        let addHorizontalLineView = UIView()
        //设置默认颜色
        addHorizontalLineView.backgroundColor = UIColor.YX_getColor(rgbValue: 0x999999)
        addHorizontalLineView.layer.cornerRadius = 1
        return addHorizontalLineView
    }()
    
    //竖线
    private lazy var addverticalLineView : UIView = {
        let verticalLineView = UIView()
        //设置默认颜色
        verticalLineView.backgroundColor = UIColor.YX_getColor(rgbValue: 0x999999)
        verticalLineView.layer.cornerRadius = 1
        return verticalLineView
    }()


    init(frame: CGRect, addminusBool: Bool, clickBlock: (() -> ())?) {
        super.init(frame: frame)
        
        self.clickBlock = clickBlock
        
        //设置默认背景颜色
        backgroundColor = UIColor.YX_getColor(rgbValue: 0xF5F5F5)
        
        if addminusBool { //减
            addSubview(mHorizontalLineView)
            mHorizontalLineView.snp.makeConstraints { (make) in
               make.centerX.equalTo(snp_centerX)
               make.centerY.equalTo(snp_centerY)
               make.width.equalTo(14)
               make.height.equalTo(2)
           }
        }else {//加
            addSubview(addHorizontalLineView)
             addHorizontalLineView.snp.makeConstraints { (make) in
                make.centerX.equalTo(snp_centerX)
                make.centerY.equalTo(snp_centerY)
                make.width.equalTo(14)
                make.height.equalTo(2)
            }
            
            addSubview(addverticalLineView)
            addverticalLineView.snp.makeConstraints { (make) in
                make.centerX.equalTo(snp_centerX)
                make.centerY.equalTo(snp_centerY)
                make.width.equalTo(2)
                make.height.equalTo(14)
            }
        }
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(YX_click)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension YXAddReduceView {
    @objc private func YX_click(){
        if clickBlock != nil {
            clickBlock!()
        }
    }
}
