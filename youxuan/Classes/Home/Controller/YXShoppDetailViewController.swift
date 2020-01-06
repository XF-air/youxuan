//
//  YXShoppDetailViewController.swift
//  youxuan
//
//  Created by 肖锋 on 2019/11/1.
//  Copyright © 2019 肖锋. All rights reserved.
//

import UIKit
import WebKit
import Alamofire

private let YXcontentSizeHeight : CGFloat = 574
private let YXcontentViewHeight : CGFloat = 537
private let YXtopContentHeight : CGFloat = 222
private let YXmiddleContentHeight : CGFloat = 290
class YXShoppDetailViewController: YXBaseViewController {
    
    var skuId : String = ""
    private var unit : String = ""
    
    var count : Int = 0
    var salesUnitCount : Int = 0
    
    private let shoppDetailViewModel : YXShoppDetailViewModel = YXShoppDetailViewModel()
    
    private lazy var immediatePurchaseBtn : YXButtonView = { [weak self] in
        let immediatePurchaseBtn = YXButtonView(frame: CGRect.zero, titleText: "立即购买", isWhiteBool: true) {
            self?.shoppDetailViewModel.skuId = self!.skuId
            self?.shoppDetailViewModel.YX_getGoodsInfo {
                if Int(self!.countLabel.text!)! > Int(self!.shoppDetailViewModel.goodsModel.stock)! {
                    YXMBProgressHUDTools.YX_presentHudWithMessage(message: "库存不足,请重新选择")
                    return
                }
                let placeOrdersVC = YXPlaceOrdersViewController()
                placeOrdersVC.skuId  = self!.skuId
                placeOrdersVC.weight = self!.countLabel.text!
                self?.rt_navigationController.pushViewController(placeOrdersVC, animated: true, complete: nil)
            }
        }
        immediatePurchaseBtn.textColorBool = true
        return immediatePurchaseBtn
    }()
    
    private lazy var contentScrollerView : UIScrollView = {
        let contentScrollerView = UIScrollView()
        contentScrollerView.backgroundColor = UIColor.white
        contentScrollerView.contentSize = CGSize(width: YXScreenW, height: YXcontentViewHeight)
        contentScrollerView.showsVerticalScrollIndicator = false
        contentScrollerView.showsHorizontalScrollIndicator = false
        return contentScrollerView
    }()
    
    private lazy var contentView : UIView = {
        let contentView = UIView(frame: CGRect(x: 0, y: 0, width: YXScreenW, height: YXcontentViewHeight))
        contentView.backgroundColor = UIColor.white
        return contentView
    }()
    
    private lazy var topContentView : YXShadowLayerView = {
        let topContentView = YXShadowLayerView(frame: CGRect(x: 0, y: 15, width: YXScreenW, height: YXtopContentHeight), shadowColor: UIColor.YX_getColor(rgbValue: 0xF5F5F5), offset: CGSize(width: 0, height: 7.5))
        return topContentView
    }()
    
    private lazy var cycleScrollerView : SDCycleScrollView = {
        let cycleScrollerView = SDCycleScrollView(frame: CGRect.zero, delegate: self, placeholderImage: nil)
        cycleScrollerView?.clipsToBounds = true
        cycleScrollerView?.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter
        cycleScrollerView?.currentPageDotColor = UIColor.YX_getColor(rgbValue: 0xFFFFFF)
        cycleScrollerView?.pageControlDotSize = CGSize(width: 6, height: 6)
        cycleScrollerView?.pageControlBottomOffset = -5
        cycleScrollerView?.autoScroll = false
        cycleScrollerView?.bannerImageViewContentMode = .scaleAspectFill
        return cycleScrollerView!
    }()
    
    private lazy var pageCountBtn : UIButton = {
        let pageCountBtn = UIButton(type: UIButton.ButtonType.custom)
        pageCountBtn.layer.cornerRadius = 10
        pageCountBtn.layer.borderColor = UIColor.YX_getColor(rgbValue: 0x979797).cgColor
        pageCountBtn.layer.borderWidth = 0.5
        pageCountBtn.setTitle("0/4", for: .normal)
        pageCountBtn.titleLabel?.font = UIFont(name: "PingFang-SC-Regular", size: 10)
        pageCountBtn.setTitleColor(UIColor.YX_getColor(rgbValue: 0x4A4A4A), for: .normal)
        return pageCountBtn
    }()
    
    private lazy var middleContentView : UIView = {
        let middleContentView = UIView()
        middleContentView.backgroundColor = UIColor.white
        return middleContentView
    }()
    
    private lazy var goodsTtitleLabel : UILabel = {
        let goodsTtitleLabel = UILabel()
        goodsTtitleLabel.textColor = UIColor.YX_getColor(rgbValue: 0x4A4A4A)
        goodsTtitleLabel.font = UIFont(name: "PingFang-SC-Semibold", size: 18)
        goodsTtitleLabel.textAlignment = .left
        return goodsTtitleLabel
    }()
    
    private lazy var moneyTitleLabel : UILabel = {
        let moneyTitleLabel = UILabel()
        moneyTitleLabel.textColor = UIColor.YX_getColor(rgbValue: 0xFF3F4D)
        moneyTitleLabel.font = UIFont(name: "PingFang-SC-Medium", size: 16.5)
        moneyTitleLabel.text = "¥"
        moneyTitleLabel.textAlignment = .left
        return moneyTitleLabel
    }()
    
    private lazy var moneyContentLabel : UILabel = {
        let moneyContentLabel = UILabel()
        moneyContentLabel.textColor = UIColor.YX_getColor(rgbValue: 0xFF3F4D)
        moneyContentLabel.font = UIFont(name: "PingFang-SC-Medium", size: 22.5)
        moneyContentLabel.textAlignment = .left
        return moneyContentLabel
    }()
    
    private lazy var retailPriceTitleLabel : UILabel = {
        let retailPriceTitleLabel = UILabel()
        retailPriceTitleLabel.textColor = UIColor.YX_getColor(rgbValue: 0x9B9B9B)
        retailPriceTitleLabel.font = UIFont(name: "PingFang-SC-Regular", size: 9.6)
        retailPriceTitleLabel.text = "¥"
        retailPriceTitleLabel.textAlignment = .left
        return retailPriceTitleLabel
    }()
    
    private lazy var retailPriceContentLabel : UILabel = {
        let retailPriceContentLabel = UILabel()
        retailPriceContentLabel.textColor = UIColor.YX_getColor(rgbValue: 0x9B9B9B)
        retailPriceContentLabel.font = UIFont(name: "PingFang-SC-Regular", size: 14.4)
        retailPriceContentLabel.textAlignment = .left
        return retailPriceContentLabel
    }()
    
    private lazy var lineView : UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor.YX_getColor(rgbValue: 0x9B9B9B)
        return lineView
    }()
    
    private lazy var surplusLabel : UILabel = {
        let surplusLabel = UILabel()
        surplusLabel.textColor = UIColor.YX_getColor(rgbValue: 0x9B9B9B)
        surplusLabel.font = UIFont(name: "PingFang-SC-Regular", size: 12)
        surplusLabel.textAlignment = .right
        return surplusLabel
    }()
    
    private lazy var arrivaltimeView : YXArrivaltimeView = {
        let arrivaltimeView = YXArrivaltimeView()
        return arrivaltimeView
    }()
    
    private lazy var buyingCattyLabel : UILabel = {
        let buyingCattyLabel = UILabel()
        buyingCattyLabel.textColor = UIColor.YX_getColor(rgbValue: 0x4A4A4A)
        buyingCattyLabel.font = UIFont(name: "PingFang-SC-Semibold", size: 16)
        buyingCattyLabel.textAlignment = .left
        buyingCattyLabel.text = "购买斤数"
        return buyingCattyLabel
    }()
    
    private lazy var wholeBasketPriceView : YXWholeBasketPriceView = {
        let wholeBasketPriceView = YXWholeBasketPriceView()
        return wholeBasketPriceView
    }()
    
    private lazy var addReduceView : YXAddReduceView = {
        let addReduceView = YXAddReduceView(frame: CGRect.zero, addminusBool: false) {
            self.YX_addCount()
        }
        return addReduceView
    }()
    
    private lazy var countLabel : UILabel = {
        let countLabel = UILabel()
        countLabel.text = "0"
        countLabel.backgroundColor = UIColor.YX_getColor(rgbValue: 0xF5F5F5)
        countLabel.textAlignment = .center
        countLabel.textColor = UIColor.YX_getColor(rgbValue: 0x4A4A4A)
        countLabel.font = UIFont(name: "PingFang-SC-Regular", size: 16)
        return countLabel
    }()
    
    private lazy var mReduceView : YXAddReduceView = {
        let mReduceView = YXAddReduceView(frame: CGRect.zero, addminusBool: true) {
            self.YX_reduceCount()
        }
        return mReduceView
    }()
    
    private lazy var middleLineView : UIView = {
        let middleLineView = UIView()
        middleLineView.backgroundColor = UIColor.YX_getColor(rgbValue: 0xF5F6F7)
        middleLineView.isHidden = true
        return middleLineView;
    }()
    
    private lazy var goodsDetailLabel : UILabel = {
        let goodsDetailLabel = UILabel()
        goodsDetailLabel.textColor = UIColor.YX_getColor(rgbValue: 0x32312D)
        goodsDetailLabel.font = UIFont(name: "PingFang-SC-Medium", size: 16)
        goodsDetailLabel.textAlignment = .left
        goodsDetailLabel.text = "商品详情"
        goodsDetailLabel.isHidden = true
        return goodsDetailLabel
    }()
    
    private lazy var myWebView : UIWebView = {
        let myWebView = UIWebView()
        myWebView.scrollView.isScrollEnabled = false
        myWebView.delegate = self
        myWebView.isHidden = true
        myWebView.backgroundColor = UIColor.clear
        myWebView.isOpaque = false
        return myWebView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        YX_setUpUI()
        
        YX_requestData()
        
    }
    
    deinit {
        print("商品详情页面销毁了")
    }
}

//添加控件
extension YXShoppDetailViewController {
    private func YX_setUpUI() {
        self.view.addSubview(immediatePurchaseBtn)
        immediatePurchaseBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp_left)
            make.right.equalTo(self.view.snp_right)
            make.height.equalTo(74)
            make.bottom.equalTo(self.view.snp_bottom)
        }
        
        self.view.addSubview(contentScrollerView)
        contentScrollerView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp_top)
            make.left.equalTo(self.view.snp_left)
            make.right.equalTo(self.view.snp_right)
            make.bottom.equalTo(immediatePurchaseBtn.snp_top)
        }
        contentScrollerView.addSubview(contentView)
        contentView.addSubview(topContentView)
        topContentView.addSubview(cycleScrollerView)
        cycleScrollerView.snp.makeConstraints { (make) in
            make.top.equalTo(topContentView.snp_top)
            make.height.width.equalTo(192)
            make.centerX.equalTo(topContentView.snp_centerX)
        }
        
        topContentView.addSubview(pageCountBtn)
        pageCountBtn.snp.makeConstraints { (make) in
            make.width.equalTo(39)
            make.height.equalTo(20)
            make.bottom.equalTo(topContentView.snp_bottom).offset(-30)
            make.right.equalTo(topContentView.snp_right).offset(-15)
        }
        
        contentView.addSubview(middleContentView)
        middleContentView.snp.makeConstraints { (make) in
            make.top.equalTo(topContentView.snp_bottom).offset(10)
            make.left.equalTo(topContentView.snp_left)
            make.right.equalTo(topContentView.snp_right)
            make.height.equalTo(YXmiddleContentHeight)
        }
        middleContentView.addSubview(goodsTtitleLabel)
        goodsTtitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(middleContentView.snp_top).offset(10)
            make.left.equalTo(middleContentView.snp_left).offset(15)
        }
        middleContentView.addSubview(moneyTitleLabel)
        moneyTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(goodsTtitleLabel.snp_left)
            make.top.equalTo(goodsTtitleLabel.snp_bottom).offset(15)
        }
        middleContentView.addSubview(moneyContentLabel)
        moneyContentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(moneyTitleLabel.snp_right)
            make.bottom.equalTo(moneyTitleLabel.snp_bottom).offset(2)
        }
        middleContentView.addSubview(retailPriceTitleLabel)
        retailPriceTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(moneyContentLabel.snp_right).offset(12)
            make.bottom.equalTo(moneyContentLabel.snp_bottom).offset(-4)
        }
        middleContentView.addSubview(retailPriceContentLabel)
        retailPriceContentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(retailPriceTitleLabel.snp_right)
            make.bottom.equalTo(retailPriceTitleLabel.snp_bottom).offset(2)
        }
        middleContentView.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.left.equalTo(retailPriceTitleLabel.snp_left).offset(-3)
            make.right.equalTo(retailPriceContentLabel.snp_right).offset(3)
            make.centerY.equalTo(retailPriceContentLabel.snp_centerY)
            make.height.equalTo(0.5)
        }
        middleContentView.addSubview(surplusLabel)
        surplusLabel.snp.makeConstraints { (make) in
            make.right.equalTo(middleContentView.snp_right).offset(-15)
            make.centerY.equalTo(moneyContentLabel.snp_centerY)
        }
        middleContentView.addSubview(arrivaltimeView)
        arrivaltimeView.snp.makeConstraints { (make) in
            make.right.equalTo(middleContentView.snp_right).offset(-10)
            make.left.equalTo(middleContentView.snp_left).offset(10)
            make.height.equalTo(44)
            make.top.equalTo(moneyContentLabel.snp_bottom).offset(20)
        }
        middleContentView.addSubview(buyingCattyLabel)
        buyingCattyLabel.snp.makeConstraints { (make) in
            make.left.equalTo(middleContentView.snp_left).offset(15)
            make.top.equalTo(arrivaltimeView.snp_bottom).offset(25)
        }
        middleContentView.addSubview(wholeBasketPriceView)
        wholeBasketPriceView.snp.makeConstraints { (make) in
            make.left.equalTo(middleContentView.snp_left).offset(15)
            make.top.equalTo(buyingCattyLabel.snp_bottom).offset(4)
            make.right.equalTo(middleContentView.snp_right).offset(-15)
            make.height.equalTo(14)
        }
        
        middleContentView.addSubview(addReduceView)
        addReduceView.snp.makeConstraints { (make) in
            make.top.equalTo(arrivaltimeView.snp_bottom).offset(25)
            make.right.equalTo(middleContentView.snp_right).offset(-10)
            make.height.equalTo(30)
            make.width.equalTo(35)
        }
        
        middleContentView.addSubview(countLabel)
        countLabel.snp.makeConstraints { (make) in
            make.top.equalTo(addReduceView.snp_top)
            make.right.equalTo(addReduceView.snp_left).offset(-1)
            make.height.equalTo(addReduceView.snp_height)
            make.width.equalTo(40)
        }
        
        middleContentView.addSubview(mReduceView)
        mReduceView.snp.makeConstraints { (make) in
            make.top.equalTo(addReduceView.snp_top)
            make.right.equalTo(countLabel.snp_left).offset(-1)
            make.height.equalTo(addReduceView.snp_height)
            make.width.equalTo(addReduceView.snp_width)
        }
        
        middleContentView.addSubview(middleLineView)
        middleLineView.snp.makeConstraints { (make) in
            make.top.equalTo(mReduceView.snp_bottom).offset(35)
            make.right.equalTo(middleContentView.snp_right)
            make.height.equalTo(10)
            make.left.equalTo(middleContentView.snp_left)
        }
        
        middleContentView.addSubview(goodsDetailLabel)
        goodsDetailLabel.snp.makeConstraints { (make) in
            make.top.equalTo(middleLineView.snp_bottom).offset(15)
            make.left.equalTo(middleContentView.snp_left).offset(15)
        }
        
        contentScrollerView.addSubview(myWebView)
        myWebView.snp.makeConstraints { (make) in
            make.left.equalTo(view.snp_left)
            make.right.equalTo(view.snp_right)
            make.height.equalTo(0.5)
            make.top.equalTo(middleContentView.snp_bottom)
        }
        
    }
}

//轮播图的代理
extension YXShoppDetailViewController : SDCycleScrollViewDelegate {
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didScrollTo index: Int) {
        pageCountBtn.setTitle("\(index + 1)/\(self.shoppDetailViewModel.bannerArray.count)", for: .normal)
    }
    
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didSelectItemAt index: Int) {
    }
}

//数据赋值
extension YXShoppDetailViewController {
    private func YX_requestData(){
        shoppDetailViewModel.skuId = skuId
        shoppDetailViewModel.YX_getDetail {
            switch self.shoppDetailViewModel.goodsModel.unitMeasure {
                case 1: self.unit = "斤"
                case 2: self.unit = "箱"
                case 3: self.unit = "两"
                case 4: self.unit = "盒"
                case 5: self.unit = "包"
                case 6: self.unit = "件"
                case 7: self.unit = "个"
                default: self.unit = "串"
            }
            self.pageCountBtn.setTitle("\(1)/\(self.shoppDetailViewModel.bannerArray.count)", for: .normal)
            self.shoppDetailViewModel.goodsModel.unit = self.unit
            self.surplusLabel.text = "剩余\(self.shoppDetailViewModel.goodsModel.stock)\(self.unit)"
            self.goodsTtitleLabel.text = self.shoppDetailViewModel.goodsModel.name
            self.moneyContentLabel.text = self.shoppDetailViewModel.goodsModel.price
            self.arrivaltimeView.arrivaStr = self.shoppDetailViewModel.goodsModel.estimatedTime
            self.wholeBasketPriceView.goodsModel = self.shoppDetailViewModel.goodsModel
            if self.shoppDetailViewModel.goodsModel.price == self.shoppDetailViewModel.goodsModel.retailPrice || self.shoppDetailViewModel.goodsModel.retailPrice.count == 0{
                self.retailPriceTitleLabel.isHidden = true
                self.retailPriceContentLabel.isHidden = true
                self.lineView.isHidden = true
            }else {
                self.retailPriceContentLabel.text = self.shoppDetailViewModel.goodsModel.retailPrice
            }
            self.cycleScrollerView.imageURLStringsGroup = self.shoppDetailViewModel.bannerUrlArray
            if self.shoppDetailViewModel.bannerArray.count == 0 {
                self.pageCountBtn.isHidden = true
            }
            self.count = self.shoppDetailViewModel.goodsModel.salesUnit
            self.salesUnitCount = self.count
            //设置购买的斤数默认值
            self.countLabel.text = String(self.count)
        }
        
        //获取到的html文件内容
        shoppDetailViewModel.YX_getHtmlData {
            if self.shoppDetailViewModel.htmlJson.count != 0 {
                self.middleLineView.isHidden = false
                self.goodsDetailLabel.isHidden = false
                self.myWebView.loadHTMLString(self.shoppDetailViewModel.htmlJson, baseURL: nil)
            }else {
                self.contentView.frame = CGRect(x: 0, y: 0, width: YXScreenW, height: YXcontentViewHeight - 63)
                self.middleContentView.snp.updateConstraints { (make) in
                    make.height.equalTo(YXmiddleContentHeight - 63)
                }
            }
        }
        
    }
}

//加和减
extension YXShoppDetailViewController {
    private func YX_addCount(){
        count = count + salesUnitCount
        if count > Int(self.shoppDetailViewModel.goodsModel.stock)! {
            YXMBProgressHUDTools.YX_presentHudWithMessage(message: "亲,该宝贝不能购买更多哦")
            count = count - salesUnitCount
            return
        }
        countLabel.text = String(count)
    }
    
    private func YX_reduceCount(){
        if count == salesUnitCount {
            YXMBProgressHUDTools.YX_presentHudWithMessage(message: "受不了了,宝贝不能再减少了哦")
            return
        }
        count = count - salesUnitCount
        countLabel.text = String(count)
    }
}

//加载出来的webviews之后调用
extension YXShoppDetailViewController : UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.myWebView.isHidden = false
        let contentHeightStr = myWebView.stringByEvaluatingJavaScript(from: "document.body.scrollHeight")
        let contentHeight = CGFloat((contentHeightStr! as NSString).floatValue)
        self.myWebView.snp.updateConstraints { (make) in
            make.height.equalTo(contentHeight)
        }
        self.contentScrollerView.contentSize = CGSize(width: YXScreenW, height: YXcontentViewHeight + contentHeight)
        
    }
}
