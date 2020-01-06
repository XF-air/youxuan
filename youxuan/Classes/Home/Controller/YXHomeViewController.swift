//
//  YXHomeViewController.swift
//  youxuan
//
//  Created by 肖锋 on 2019/10/14.
//  Copyright © 2019年 肖锋. All rights reserved.
//

import UIKit
import JXPagingView
import JXCategoryView

//headerView的高度(这里暂时固定住)
private let YXTableHeaderViewHeight : CGFloat = 212
//标题的高度
private let YXHeaderInSectionHeight : CGFloat = 50

class YXHomeViewController: YXBaseViewController {
    
    private var pagingView : JXPagingView!
    private var categoryView : JXCategoryTitleView!
    private var homeHeaderView : YXHomeHeaderView!
    
    private var navTitleView : UIView? = nil
    
    private let homeShoppViewModel : YXHomeShoppViewModel = YXHomeShoppViewModel()
    
    private lazy var titleImageView : UIImageView = {
        let titleImageView = UIImageView(image: UIImage(named: "logo2"))
        return titleImageView
    }()
    
    private lazy var locationTitleView : YXLocationTitleView = {
        let locationTitleView = YXLocationTitleView(frame: CGRect.zero) {}
        return locationTitleView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //不要调整控制器得内边距（有些会造成页面向下偏移64）
        automaticallyAdjustsScrollViewInsets = false
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        NotificationCenter.default.addObserver(self, selector: #selector(YX_requestData), name: NSNotification.Name(rawValue: YXRECEIVEDLOCATIONNOTIFICATION), object: nil)
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    @objc private func headerRefresh() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(2)) {

            self.categoryView.titles = self.homeShoppViewModel.titleNames as? [String]
            self.categoryView.reloadData()

            self.pagingView.mainTableView.mj_header.endRefreshing()
            self.pagingView.reloadData()
            
        }
    }
    
    @objc private func YX_requestData(){
        homeShoppViewModel.YX_requestTotal {
            if self.homeShoppViewModel.titleNames.count != 0 {
                self.YX_setUpHeaderView(titles: self.homeShoppViewModel.titleNames)
            }
        }
    }
    
    func mainTableViewDidScroll(_ scrollView: UIScrollView) {
        let thresholdDistance: CGFloat = 100
        var percent = scrollView.contentOffset.y / thresholdDistance
        percent = max(0, min(1, percent))
        navTitleView!.alpha = percent
    }

}

//设置headerView相关的东西
extension YXHomeViewController {
    private func YX_setUpHeaderView(titles: NSMutableArray){
        
        homeHeaderView = YX_homeHeaderView()
        categoryView = JXCategoryTitleView(frame: CGRect(x: 10, y: 0, width: YXScreenW - 20, height: CGFloat(YXHeaderInSectionHeight)))
        categoryView.titles = self.homeShoppViewModel.titleNames as? [String]
        categoryView.contentEdgeInsetLeft = 30
        categoryView.contentEdgeInsetRight = 30
        categoryView.cellSpacing = 36
        categoryView.backgroundColor = UIColor.white
        categoryView.titleSelectedColor = UIColor.YX_getColor(rgbValue: 0x32312D)
        categoryView.titleColor = UIColor.YX_getColor(rgbValue: 0x32312D)
        categoryView.titleFont = UIFont(name: "PingFang-SC-Regular", size: 15)
        categoryView.isTitleColorGradientEnabled = true
        categoryView.isTitleLabelZoomEnabled = true
        categoryView.delegate = self

        let lineView = JXCategoryIndicatorLineView()
        lineView.indicatorColor = UIColor.red
        lineView.indicatorWidth = 30
        categoryView.indicators = [lineView]
        
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: YXHeaderInSectionHeight))
        leftView.backgroundColor = UIColor.YX_getColor(rgbValue: 0xF5F6F7)
        categoryView.addSubview(leftView)
        let rightView = UIView(frame: CGRect(x: YXScreenW - 10, y: 0, width: 10, height: YXHeaderInSectionHeight))
        rightView.backgroundColor = UIColor.YX_getColor(rgbValue: 0xF5F6F7)
        categoryView.addSubview(rightView)
        
        pagingView = YX_preferredPagingView()
        pagingView.frame = self.view.bounds
        self.view.addSubview(pagingView)
        categoryView.contentScrollView = pagingView.listContainerView.collectionView
        
        self.pagingView.mainTableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(self.headerRefresh))
        
        self.YX_setUpUI()

    }
    
    private func YX_homeHeaderView() -> YXHomeHeaderView {
        return YXHomeHeaderView(frame: CGRect.zero) { (bannerId) in
            
        }
    }

    private func YX_preferredPagingView() -> JXPagingView {
        return JXPagingView(delegate: self)
        
        
    }
}

//添加控件和自定义导航栏
extension YXHomeViewController {
    private func YX_setUpUI(){
        
        let naviHeight = UIApplication.shared.keyWindow!.YX_navigationHeight()
        pagingView.pinSectionHeaderVerticalOffset = Int(naviHeight)

        navTitleView = UIView()
        navTitleView?.alpha = 0
        navTitleView?.backgroundColor = UIColor.white
        navTitleView?.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: naviHeight)
        self.view.addSubview(navTitleView!)
        
        navTitleView!.addSubview(titleImageView)
        titleImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(navTitleView!.snp_centerX)
            make.height.equalTo(21)
            make.width.equalTo(84)
            make.bottom.equalTo(navTitleView!.snp_bottom)
        }

        navTitleView!.addSubview(locationTitleView)
        locationTitleView.snp.makeConstraints { (make) in
            make.left.equalTo(navTitleView!.snp_left)
            make.right.equalTo(titleImageView.snp_left).offset(-10)
            make.bottom.equalTo(titleImageView.snp_bottom)
            make.height.equalTo(21)
        }
    }
}

extension YXHomeViewController : JXPagingViewDelegate {
    
    func tableHeaderViewHeight(in pagingView: JXPagingView) -> Int {
        return Int(YXTableHeaderViewHeight)
    }

    func tableHeaderView(in pagingView: JXPagingView) -> UIView {
        return homeHeaderView
    }

    func heightForPinSectionHeader(in pagingView: JXPagingView) -> Int {
        return Int(YXHeaderInSectionHeight)
    }

    func viewForPinSectionHeader(in pagingView: JXPagingView) -> UIView {
        return categoryView
    }

    func numberOfLists(in pagingView: JXPagingView) -> Int {
        return self.homeShoppViewModel.titleNames.count
    }

    func pagingView(_ pagingView: JXPagingView, initListAtIndex index: Int) -> JXPagingViewListViewDelegate {
        let homeListView = YXHomeListView()
        homeListView.naviController = self.rt_navigationController
        homeShoppViewModel.YX_requestTitleContentData(goodsId: homeShoppViewModel.titles[index].shoppTitleModel_id) {
            homeListView.dataSource = self.homeShoppViewModel.homeLists
            self.homeHeaderView.goodsModel = self.homeShoppViewModel.goodsModel
        }
        homeListView.beginFirstRefresh()
        return homeListView
    }
}

extension YXHomeViewController : JXCategoryViewDelegate {
    func categoryView(_ categoryView: JXCategoryBaseView!, didSelectedItemAt index: Int) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = (index == 0)
    }
    
    func categoryView(_ categoryView: JXCategoryBaseView!, didClickedItemContentScrollViewTransitionTo index: Int){
        self.pagingView.listContainerView.collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: false)
        let diffIndex = abs(categoryView.selectedIndex - index)
        if diffIndex > 1 {
            self.pagingView.listContainerView.collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: false)
        }else {
            self.pagingView.listContainerView.collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
}


