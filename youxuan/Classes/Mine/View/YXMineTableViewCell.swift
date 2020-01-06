//
//  YXMineTableViewCell.swift
//  youxuan
//
//  Created by 肖锋 on 2019/10/21.
//  Copyright © 2019 肖锋. All rights reserved.
//

import UIKit

class YXMineTableViewCell: UITableViewCell {
    
    var clickblock : ((Int) -> ())?
    
   private lazy var yxcontentView : YXShadowBaseView = {
        let yxcontentView = YXShadowBaseView(frame: CGRect.zero, shadowColor: UIColor.YX_getColor(rgbValue: 0xF2F2F2), shadowSize: CGSize(width: 0, height: 7), shadowRadius: 12, cornerRadius: 10)        
        return yxcontentView
    }()

    lazy var firestCellView : YXMineCellMessageView = {
        let firestCellView = YXMineCellMessageView(frame: CGRect.zero) { (tag) in
            self.YX_clickCell(tag: tag)
        }
        return firestCellView
    }()
    
    lazy var secondCellView : YXMineCellMessageView = {
        let secondCellView = YXMineCellMessageView(frame: CGRect.zero) { (tag) in
            self.YX_clickCell(tag: tag)
        }
        return secondCellView
    }()

    lazy var thirdCellView : YXMineCellMessageView = {
        let thirdCellView = YXMineCellMessageView(frame: CGRect.zero) { (tag) in
            self.YX_clickCell(tag: tag)
        }
        return thirdCellView
    }()

    lazy var fourCellView : YXMineCellMessageView = {
        let fourCellView = YXMineCellMessageView(frame: CGRect.zero) { (tag) in
            self.YX_clickCell(tag: tag)
        }
        return fourCellView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = UIColor.YX_getColor(rgbValue: 0xFAFAFA)
        YX_setUpCellContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//添加控件
extension YXMineTableViewCell {
    private func YX_setUpCellContent(){
        contentView.addSubview(yxcontentView)
        yxcontentView.snp.makeConstraints { (make) in
            make.left.equalTo(contentView.snp.left).offset(10)
            make.top.equalTo(contentView.snp.top).offset(7.5)
            make.right.equalTo(contentView.snp.right).offset(-10)
            make.bottom.equalTo(contentView.snp.bottom).offset(-7.5)
        }
        yxcontentView.addSubview(firestCellView)
        firestCellView.snp.makeConstraints { (make) in
            make.left.equalTo(yxcontentView.snp.left)
            make.right.equalTo(yxcontentView.snp.right)
            make.height.equalTo(54)
            make.top.equalTo(yxcontentView.snp.top).offset(5)
        }
        
        yxcontentView.addSubview(secondCellView)
        secondCellView.snp.makeConstraints { (make) in
            make.left.equalTo(firestCellView.snp.left)
            make.right.equalTo(firestCellView.snp.right)
            make.height.equalTo(firestCellView.snp.height)
            make.top.equalTo(firestCellView.snp.bottom)
        }
        
        yxcontentView.addSubview(thirdCellView)
        thirdCellView.snp.makeConstraints { (make) in
            make.left.equalTo(firestCellView.snp.left)
            make.right.equalTo(firestCellView.snp.right)
            make.height.equalTo(firestCellView.snp.height)
            make.top.equalTo(secondCellView.snp.bottom)
        }
        
        yxcontentView.addSubview(fourCellView)
        fourCellView.snp.makeConstraints { (make) in
            make.left.equalTo(firestCellView.snp.left)
            make.right.equalTo(firestCellView.snp.right)
            make.height.equalTo(firestCellView.snp.height)
            make.top.equalTo(thirdCellView.snp.bottom)
        }
    }
}

//闭包实现
extension YXMineTableViewCell {
    private func YX_clickCell(tag: Int) {
        if clickblock != nil {
            clickblock!(tag)
        }
    }
}
