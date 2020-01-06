//
//  YXPlaceOrdersViewController.swift
//  youxuan
//
//  Created by 肖锋 on 2019/11/19.
//  Copyright © 2019 肖锋. All rights reserved.
//

import UIKit

private let contentSizeHeight : CGFloat = 461

class YXPlaceOrdersViewController: YXBaseViewController {
    
    var skuId : String = ""
    var weight : String = ""
    
    private var placeOrdersViewModel : YXPlaceOrdersViewModel = YXPlaceOrdersViewModel()
    
    //添加scrollerview
    private lazy var contentScrollerView : UIScrollView = {
        let contentScrollerView = UIScrollView()
        contentScrollerView.showsVerticalScrollIndicator = false
        contentScrollerView.showsHorizontalScrollIndicator = false
        contentScrollerView.contentSize = CGSize(width: YXScreenW, height: contentSizeHeight)
        contentScrollerView.backgroundColor = UIColor.YX_getColor(rgbValue: 0xF5F6F7)
        contentScrollerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(YX_endEdit)))
        return contentScrollerView
    }()
    
    private lazy var payBaseView : YXPayBaseView = {
        let payBaseView = YXPayBaseView(frame: CGRect.zero) { [unowned self] in
            self.YX_creatOrder()
        }
        return payBaseView
    }()
    
    //添加内容
    private lazy var contentView : UIView = {
        let contentView = UIView(frame: CGRect(x: 0, y: 0, width: YXScreenW, height: contentSizeHeight))
        contentView.backgroundColor = UIColor.YX_getColor(rgbValue: 0xF5F6F7)
        return contentView
    }()
    
    private lazy var placeOrdersTopView : YXPlaceOrdersTopView = {
        let placeOrdersTopView = YXPlaceOrdersTopView(frame: CGRect(x: 10, y: 10, width: YXScreenW - 20, height: 91)) {
            
        }
        return placeOrdersTopView
    }()
    
    private lazy var placeOrdersMiddleView : YXPlaceOrdersMiddleView = {
        let placeOrdersMiddleView = YXPlaceOrdersMiddleView(frame: CGRect.zero, commodityClickBlock: {
            
        }, couponClickBlock: {
            self.rt_navigationController.pushViewController(YXCouponViewController(), animated: true, complete: nil)
        }) {
            
        }
        return placeOrdersMiddleView
    }()
    
    private lazy var placeOrdersBottomRemarkView : YXPlaceOrdersBottomRemarkView = {
        let placeOrdersBottomRemarkView = YXPlaceOrdersBottomRemarkView()
        return placeOrdersBottomRemarkView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "下单";
        
        YX_setUpUI()
        
        YX_getData()
        
        
    }
    
}

//添加控件
extension YXPlaceOrdersViewController {
    private func YX_setUpUI(){
        
        view.addSubview(payBaseView)
        payBaseView.snp.makeConstraints { (make) in
            make.left.equalTo(view.snp_left)
            make.right.equalTo(view.snp_right)
            make.height.equalTo(74)
            make.bottom.equalTo(view.snp_bottom)
        }
        
        view.addSubview(contentScrollerView)
        contentScrollerView.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp_top)
            make.left.equalTo(view.snp_left)
            make.right.equalTo(view.snp_right)
            make.bottom.equalTo(payBaseView.snp_top)
        }
        
        contentScrollerView.addSubview(contentView)
        contentScrollerView.addSubview(placeOrdersTopView)
        contentScrollerView.addSubview(placeOrdersMiddleView)
        placeOrdersMiddleView.snp.makeConstraints { (make) in
            make.top.equalTo(placeOrdersTopView.snp_bottom).offset(10)
            make.left.equalTo(placeOrdersTopView.snp_left)
            make.right.equalTo(placeOrdersTopView.snp_right)
            make.height.equalTo(260)
        }
        
        contentScrollerView.addSubview(placeOrdersBottomRemarkView)
        placeOrdersBottomRemarkView.snp.makeConstraints { (make) in
            make.height.equalTo(80)
            make.left.equalTo(placeOrdersTopView.snp_left)
            make.right.equalTo(placeOrdersTopView.snp_right)
            make.top.equalTo(placeOrdersMiddleView.snp_bottom).offset(10)
        }
    }
}

//数据请求
extension YXPlaceOrdersViewController {
    private func YX_getData(){
        placeOrdersViewModel.skuId = skuId
        placeOrdersViewModel.weight = weight
        placeOrdersViewModel.YX_getPlaceOrdersData {
            self.placeOrdersTopView.placeOrdersModel = self.placeOrdersViewModel.placeOrdersModel
            self.placeOrdersMiddleView.placeOrdersModel = self.placeOrdersViewModel.placeOrdersModel
            self.payBaseView.placeOrdersModel = self.placeOrdersViewModel.placeOrdersModel
        }
    }
}

//方法的监听
extension YXPlaceOrdersViewController {
    @objc private func YX_endEdit(){
        placeOrdersBottomRemarkView.remarkTextView.endEditing(true)
    }
}

//创建订单
extension YXPlaceOrdersViewController {
    private func YX_creatOrder(){
        placeOrdersViewModel.skuId = skuId
        placeOrdersViewModel.weight = weight
        placeOrdersViewModel.YX_commitCreatOrder {
            let payVC = YXBasePayViewController()
            payVC.basePayModel = self.placeOrdersViewModel.basePayModel
            self.rt_navigationController.pushViewController(payVC, animated: true) { (finish) in
                self.rt_navigationController.removeViewController(self)
            }
        }
    }
}
