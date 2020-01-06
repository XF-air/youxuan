//
//  YXHomeHeaderView.swift
//  youxuan
//
//  Created by 肖锋 on 2019/10/31.
//  Copyright © 2019 肖锋. All rights reserved.
//

import UIKit

private let YXCYCLEHEIGHT : CGFloat = 147
private let YXOPENMARKETHEIGHT : CGFloat = 55

class YXHomeHeaderView: UIView {
    
    private let homeHeaderViewModel : YXHomeHeaderViewModel = YXHomeHeaderViewModel()
    
    var goodsModel : YXGoodsModel?{
        didSet {
            guard let goodsModel = goodsModel else { return }
            openMarketView.goodsModel = goodsModel
        }
    }
    
    private lazy var cycleScrollView : SDCycleScrollView? = {
        let cycleScrollView = SDCycleScrollView(frame: CGRect.init(x: 0, y: 0, width: YXScreenW, height: YXCYCLEHEIGHT), delegate: self, placeholderImage: nil)
        cycleScrollView?.clipsToBounds = true
        cycleScrollView?.autoScrollTimeInterval = 5
        cycleScrollView?.bannerImageViewContentMode = .scaleAspectFill
        cycleScrollView?.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter
        cycleScrollView?.currentPageDotColor = UIColor.white
        cycleScrollView?.pageControlDotSize = CGSize(width: 6, height: 6)
        cycleScrollView?.pageControlBottomOffset = -5.0
        cycleScrollView?.autoScrollTimeInterval = 5.0
        return cycleScrollView
    }()
    
    private lazy var openMarketView : YXOpenMarketView = {
        let openMarketView = YXOpenMarketView(frame: CGRect(x: 10, y: self.bounds.size.height - YXOPENMARKETHEIGHT, width: YXScreenW - 20, height: YXOPENMARKETHEIGHT)) {
             
        }
        return openMarketView
    }()
    
    private lazy var imageView : UIImageView = {
       let imageView = UIImageView(image: UIImage(named: "banner"))
        return imageView
    }()
    
    private let bannerArray = NSMutableArray()
    
    var bannerClickBlock : ((String) -> ())?
    
    init(frame: CGRect, bannerClickBlock: ((String) -> ())?) {
        super.init(frame: frame)
        self.bannerClickBlock = bannerClickBlock
        
        backgroundColor = UIColor.YX_getColor(rgbValue: 0xF5F6F7)
        
        homeHeaderViewModel.YX_reloadData {
            self.YX_setUpUI()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        openMarketView.frame = CGRect(x: 10, y: self.bounds.size.height - YXOPENMARKETHEIGHT, width: YXScreenW - 20, height: YXOPENMARKETHEIGHT)
    }
}

//添加轮播图的控件
extension YXHomeHeaderView {
    private func YX_setUpUI(){
        self.addSubview(cycleScrollView!)
        cycleScrollView?.localizationImageNamesGroup = homeHeaderViewModel.bannerUrlArray
        self.addSubview(openMarketView)
        self.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.left.equalTo(snp_left)
            make.right.equalTo(snp_right)
            make.height.equalTo(10)
            make.top.equalTo(137)
        }
    }
}

//点击图片回调的代理
extension YXHomeHeaderView : SDCycleScrollViewDelegate {
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didSelectItemAt index: Int) {
        if bannerClickBlock != nil {
            bannerClickBlock!(homeHeaderViewModel.bannerArray[index].bannerId)
        }
    }
}

