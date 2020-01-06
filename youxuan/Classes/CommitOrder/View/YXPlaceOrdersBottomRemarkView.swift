//
//  YXPlaceOrdersBottomRemarkView.swift
//  youxuan
//
//  Created by 肖锋 on 2019/11/19.
//  Copyright © 2019 肖锋. All rights reserved.
//

import UIKit

class YXPlaceOrdersBottomRemarkView: YXOrdersBaseView {
    
    lazy var remarkTextView : UITextView = {
        let remarkTextView = UITextView()
        remarkTextView.backgroundColor = UIColor.YX_getColor(rgbValue: 0xF7F8F9)
        remarkTextView.textColor = UIColor.YX_getColor(rgbValue: 0x4A4A4A)
        remarkTextView.font = UIFont(name: "PingFang-SC-Light", size: 14)
        remarkTextView.delegate = self
        remarkTextView.tintColor = UIColor.YX_getColor(rgbValue: 0xB4B4B4)
        remarkTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 0)
        return remarkTextView
    }()
    
    private lazy var placehorderLabel : UILabel = {
        let placehorderLabel = UILabel()
        placehorderLabel.text = "如有需要，请输入备注信息"
        placehorderLabel.font = UIFont(name: "PingFang-SC-Light", size: 14)
        placehorderLabel.textColor = UIColor.YX_getColor(rgbValue: 0xB4B4B4)
        placehorderLabel.textAlignment = .left
        return placehorderLabel
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(remarkTextView)
        remarkTextView.snp.makeConstraints { (make) in
            make.left.equalTo(snp_left).offset(10)
            make.right.equalTo(snp_right).offset(-10)
            make.top.equalTo(snp_top).offset(10)
            make.bottom.equalTo(snp_bottom).offset(-10)
        }
        remarkTextView.addSubview(placehorderLabel)
        placehorderLabel.snp.makeConstraints { (make) in
            make.left.equalTo(remarkTextView.snp_left).offset(10)
            make.top.equalTo(remarkTextView.snp_top).offset(10)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension YXPlaceOrdersBottomRemarkView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        placehorderLabel.isHidden = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.count == 0 {
            placehorderLabel.isHidden = false
        }
    }
}
