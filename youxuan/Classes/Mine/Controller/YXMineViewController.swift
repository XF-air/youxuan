//
//  YXMineViewController.swift
//  youxuan
//
//  Created by 肖锋 on 2019/10/14.
//  Copyright © 2019年 肖锋. All rights reserved.
//

import UIKit
import zhPopupController

private let cellID = "cellID"
private let height : CGFloat = 625

class YXMineViewController: YXBaseViewController {
    
    //定义数组(图片)
    private let titleImageArray = [
                            "icon_store",
                            "icon_shopping",
                            "icon_user-oder",
                            "icons",
                            "icon_location",
                            "icon_customer-service",
                            "icon_edit",
                            ]
    //定义数组(图片对应的文字)
    private let titleNameArray = [
                            "商铺信息",
                            "我的订单",
                            "用户订单",
                            "我的优惠劵",
                            "收货地址",
                            "我的客服",
                            "意见反馈",
                            ]
    
    private lazy var mineTableView : UITableView = { [unowned self] in
        let mineTableView = UITableView(frame: CGRect.zero, style: .plain)
        mineTableView.delegate = self
        mineTableView.dataSource = self
        mineTableView.separatorStyle = .none
        mineTableView.backgroundColor = UIColor.YX_getColor(rgbValue: 0xFAFAFA)
        mineTableView.tableHeaderView = self.mineHeaderView
        mineTableView.register(YXMineTableViewCell.self, forCellReuseIdentifier: cellID)
        return mineTableView
    }()
    
    private lazy var mineHeaderView : YXMineHeaderView = { [unowned self] in
        let mineHeaderView = YXMineHeaderView(frame: CGRect(x: 0, y: 0, width: YXScreenW, height: height), loginOutBlock: {
            self.YX_loginOut()
        }, nbBlock: {
            self.YX_nbClick()
        }, pickUpGoodsBlock: {
            self.YX_pickUpGoods()
        }) {
            self.YX_jumpLoginVC()
        }
        mineHeaderView.allBtnBlock = { (tag) in
            
        }
        return mineHeaderView
    }()
    
    //创建属性我的viewModel属性
    private var mineViewModel : YXMineViewModel = YXMineViewModel()
    
    private lazy var loginOutAlreatView : YXAlreatView = { [unowned self] in
        let loginOutAlreatView = YXAlreatView(frame: CGRect(x: 30, y: 0, width: YXScreenW - 60, height: 214), title: "提示", detailTitle: "确认退出登录吗？", sureBtnTitle: "确认", sureBlock: {
            print("调用退出登录的接口")
            self.mineViewModel.YX_requestLoginOut{
                self.zh_popupController.fadeDismiss()
                self.YX_checkBusiness()
                YXUserDefulatTools.YX_removeUserDefult()
                self.rt_navigationController.pushViewController(YXLoginViewController(), animated: true)
            }
        }) {
            print("取消")
            self.zh_popupController.fadeDismiss()
        }
        return loginOutAlreatView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: true)

        view.backgroundColor = UIColor.YX_getColor(rgbValue: 0xFAFAFA)

        YX_setUpContentControl()

        YX_requestRefreshMine()
        
        YX_checkBusiness()
        
        NotificationCenter.default.addObserver(self, selector: #selector(YX_requestNotification), name: NSNotification.Name(rawValue: YXREFERSHMINENOTIFICATION), object: nil)
    }
}

//通知需要走的方法
extension YXMineViewController {
    @objc private func YX_requestNotification(){
        YX_checkBusiness()
    }
}

//调用方法查询商铺信息
extension YXMineViewController {
    private func YX_checkBusiness(){
        //这里调用viewModel里面的方法,实现mine的数据刷新
        mineViewModel.YX_requestBusinessMessage{
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                self.mineHeaderView.mineModel = self.mineViewModel.mineModel
                self.mineTableView.reloadData()
                self.mineTableView.mj_header.endRefreshing()
            }
        }
    }
}

//刷新内容
extension YXMineViewController {
    private func YX_requestRefreshMine(){
        mineTableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(YX_refreshMineMessage))
    }
}

//跳转到登录控制器
extension YXMineViewController {
    private func YX_jumpLoginVC(){
        if YXUserDefulatTools.YX_getUserDefult() == nil {
            rt_navigationController.pushViewController(YXLoginViewController(), animated: true)
        }
    }
}


//实现刷新的方法
extension YXMineViewController {
    @objc private func YX_refreshMineMessage(){
        YX_checkBusiness()
    }
}

//添加内容的tableView
extension YXMineViewController{
    private func YX_setUpContentControl(){
        view.addSubview(mineTableView)
        mineTableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.top).offset(-UIApplication.shared.statusBarFrame.size.height)
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
            make.bottom.equalTo(self.view.snp.bottom)
        }
    }
}

//这是闭包调用的方法
extension YXMineViewController {
    private func YX_loginOut(){
        print("退出登录")
        YX_putOutLogin()
    }
    
    private func YX_nbClick(){
        print("点击nb")
    }
    
    private func YX_pickUpGoods(){
        print("提货核销")
    }
}

extension YXMineViewController {
    private func YX_putOutLogin(){
        self.zh_popupController = zh_popupController
        self.zh_popupController.dismissOnMaskTouched = false
        self.zh_popupController.presentContentView(loginOutAlreatView)
    }
}

//数据源方法
extension YXMineViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! YXMineTableViewCell
        YX_setUpWithCell(cell: cell, indexPath: indexPath)
        YX_seUpTitleNameAndTitleImage(cell: cell)
        cell.clickblock = { (tag) in
            switch tag {
            case 10000:
                let addShoppMessageVC = YXAddShoppMessageViewController()
                addShoppMessageVC.navigationItem.title = "修改商铺信息"
                addShoppMessageVC.states = .YXMINETYPE
                addShoppMessageVC.updateBlock = {
                    self.YX_checkBusiness()
                }
                self.rt_navigationController.pushViewController(addShoppMessageVC, animated: true)
            case 10001:
                self.rt_navigationController.pushViewController(YXMineOrderViewController(), animated: true)
            case 10002:
                self.rt_navigationController.pushViewController(YXUserOrderViewController(), animated: true)
            case 10003:
                self.rt_navigationController.pushViewController(YXMineCouponViewController(), animated: true)
            case 20000:
                self.rt_navigationController.pushViewController(YXReceivingAddressViewController(), animated: true)
            case 20002:
                self.rt_navigationController.pushViewController(YXFeedbackViewController(), animated: true)
            default:
                print("这是我的客服")
            }
        }
        return cell
    }
}

//对cell中的内容做的设置
extension YXMineViewController {
    private func YX_setUpWithCell(cell: YXMineTableViewCell, indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            for i in 0..<4 {
                switch i {
                case 0:cell.firestCellView.tag = 10000 + i
                case 1:cell.secondCellView.tag = 10000 + i
                case 2:cell.thirdCellView.tag = 10000 + i
                default:cell.fourCellView.tag = 10000 + i; cell.fourCellView.isHidden = false
                }
            }
        default:
            for j in 0..<3 {
                switch j {
                case 0:cell.firestCellView.tag = 20000 + j
                case 1:cell.secondCellView.tag = 20000 + j
                default:cell.thirdCellView.tag = 20000 + j; cell.fourCellView.isHidden = true
                }
            }
        }
    }
}

//设置图片和文字
extension YXMineViewController {
    private func YX_seUpTitleNameAndTitleImage(cell: YXMineTableViewCell) {
        if cell.firestCellView.tag == 10000 || cell.firestCellView.tag == 20000 {
            if cell.firestCellView.tag == 10000 {
                cell.firestCellView.titleImageView.image = UIImage(named: titleImageArray[0])
                cell.firestCellView.titleLabel.text = titleNameArray[0]
            }else {
                cell.firestCellView.titleImageView.image = UIImage(named: titleImageArray[4])
                cell.firestCellView.titleLabel.text = titleNameArray[4]
            }
        }
        if cell.secondCellView.tag == 10001 || cell.secondCellView.tag == 20001 {
            if cell.secondCellView.tag == 10001 {
                cell.secondCellView.titleImageView.image = UIImage(named: titleImageArray[1])
                cell.secondCellView.titleLabel.text = titleNameArray[1]
            }else {
                cell.secondCellView.titleImageView.image = UIImage(named: titleImageArray[5])
                cell.secondCellView.titleLabel.text = titleNameArray[5]
            }
        }
        if cell.thirdCellView.tag == 10002 || cell.thirdCellView.tag == 20002 {
            if cell.thirdCellView.tag == 10002 {
                cell.thirdCellView.titleImageView.image = UIImage(named: titleImageArray[2])
                cell.thirdCellView.titleLabel.text = titleNameArray[2]
            }else {
                cell.thirdCellView.titleImageView.image = UIImage(named: titleImageArray[6])
                cell.thirdCellView.titleLabel.text = titleNameArray[6]
            }
        }
        if cell.fourCellView.tag == 10003 {
            cell.fourCellView.titleImageView.image = UIImage(named: titleImageArray[3])
            cell.fourCellView.titleLabel.text = titleNameArray[3]
        }
    }
}

//代理方法
extension YXMineViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 0 ? 241 : 187
    }
}
