//
//  YXHomeListViewController.swift
//  youxuan
//
//  Created by 肖锋 on 2019/11/1.
//  Copyright © 2019 肖锋. All rights reserved.
//

import UIKit
import JXPagingView

private let YXROWHEIGHT : CGFloat = 105
private let YXhomeListCellID = "YXhomeListCellID"

class YXHomeListView: UIView {
    
    weak var naviController: UINavigationController?
    private var tableView : UITableView!
    var dataSource : [YXGoodsModel]?{
        didSet{
            tableView.reloadData()
        }
    }
    var isNeedHeader = false {
        didSet {
            if isNeedHeader {
                self.tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(headerRefresh))
            }else if self.tableView.mj_header != nil {
                self.tableView.mj_header.endRefreshing()
                self.tableView.mj_header.removeFromSuperview()
                self.tableView.mj_header = nil
            }
        }
    }
    
    var isNeedFooter = false {
        didSet {
            if isNeedFooter {
                tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadMore))
            }else if self.tableView.mj_footer != nil {
                self.tableView.mj_footer.endRefreshing()
                self.tableView.mj_footer.removeFromSuperview()
                self.tableView.mj_footer = nil
            }
        }
    }
    
    var listViewDidScrollCallback: ((UIScrollView) -> ())?
    var lastSelectedIndexPath: IndexPath?
    var isHeaderRefreshed = false

    deinit {
        listViewDidScrollCallback = nil
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.YX_getColor(rgbValue: 0xF5F6F7)
        tableView = UITableView(frame: frame, style: .plain)
        tableView.backgroundColor = UIColor.white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = YXROWHEIGHT
        tableView.register(YXHomeTableViewCell.self, forCellReuseIdentifier: YXhomeListCellID)
        tableView.tableHeaderView = YXFilletView(frame: CGRect(x: 0, y: 0, width: YXScreenW - 20, height: 25), corner: [.topLeft, .topRight], size: CGSize(width: 10, height: 10))
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 10
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.size.width - 7)
        addSubview(tableView)
    }

    func beginFirstRefresh() {
        if !isHeaderRefreshed {
            if (self.isNeedHeader) {
                self.tableView.mj_header.beginRefreshing()
                headerRefresh()
            }else {
                print("这里是头部的刷新")
                self.isHeaderRefreshed = true
                self.tableView.reloadData()
            }
        }
    }

    @objc func headerRefresh() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(2)) {
            self.tableView.mj_header.endRefreshing()
            self.isHeaderRefreshed = true
            self.tableView.reloadData()
        }
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(snp_top).offset(-10)
            make.left.equalTo(snp_left).offset(10)
            make.right.equalTo(snp_right).offset(-10)
            make.bottom.equalTo(snp_bottom).offset(-10)
        }
        
        
}

    @objc func loadMore() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(2)) {
            print("这里是尾部的刷新")
            self.tableView.reloadData()
            self.tableView.mj_footer.endRefreshing()
        }
    }

    func selectedCell(at indexPath: IndexPath) {
        let detailVC = YXShoppDetailViewController()
        detailVC.navigationItem.title = "商品详情"
        detailVC.skuId = dataSource![indexPath.row].skuId
        self.naviController?.pushViewController(detailVC, animated: true)
    }
}

extension YXHomeListView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isHeaderRefreshed {
            return dataSource?.count ?? 0
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let homeCell = tableView.dequeueReusableCell(withIdentifier: YXhomeListCellID, for: indexPath) as! YXHomeTableViewCell
        homeCell.homeGoodsModel = dataSource?[indexPath.row]
        homeCell.bgButtonClicked = { [unowned self] in
            self.selectedCell(at: indexPath)
        }
        
        return homeCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedCell(at: indexPath)
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.listViewDidScrollCallback?(scrollView)
    }
}



extension YXHomeListView : JXPagingViewListViewDelegate {
    public func listView() -> UIView {
        return self
    }

    public func listViewDidScrollCallback(callback: @escaping (UIScrollView) -> ()) {
        self.listViewDidScrollCallback = callback
    }

    public func listScrollView() -> UIScrollView {
        return self.tableView
    }
}


