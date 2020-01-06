//
//  YXBasePayViewController.swift
//  youxuan
//
//  Created by 肖锋 on 2019/11/25.
//  Copyright © 2019 肖锋. All rights reserved.
//

import UIKit

enum YXPAYWAYTYPE {
    case YXPAY_WECHAT
    case YXPAY_ALIPAY
}
private let payCellID = "payCellID"
private let kHeaderHeight : CGFloat = 321

class YXBasePayViewController: YXBaseViewController {
    
    private var basePayViewModel : YXBasePayViewModel = YXBasePayViewModel()
    
    private var payWayType = YXPAYWAYTYPE.YXPAY_WECHAT
    
    private var isCancelOrderBool : Bool = true
    
    var basePayModel : YXBasePayModel? {
        didSet{
           guard let basePayModel = basePayModel else {return}
            basePayHeaderView.basePayModel = basePayModel
            basePayViewModel.orderId = basePayModel.orderId
        }
    }
    
    private let arrayDict = [["name":"微信","icon":"icon_weixin"],["name":"支付宝","icon":"icon_zhifubao"]]
    
    private lazy var confirmPaymentBtn : YXButtonView = {
        let confirmPaymentBtn = YXButtonView(frame: CGRect.zero, titleText: "确认支付", isWhiteBool: true) {
            self.YX_confirmPayment()
        }
        confirmPaymentBtn.textColorBool = false
        return confirmPaymentBtn
    }()
    
    private lazy var payTableView : UITableView = {
        let payTableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        payTableView.separatorStyle = .none
        payTableView.showsVerticalScrollIndicator = false
        payTableView.showsHorizontalScrollIndicator = false
        payTableView.delegate = self
        payTableView.dataSource = self
        payTableView.rowHeight = 44
        payTableView.tableHeaderView = basePayHeaderView
        payTableView.register(YXBasePayTableViewCell.self, forCellReuseIdentifier: payCellID)
        return payTableView
    }()
    
    private lazy var basePayHeaderView : YXBasePayHeaderView = {
        let basePayHeaderView = YXBasePayHeaderView(frame: CGRect(x: 0, y: 0, width: YXScreenW, height: kHeaderHeight)) {
            
        }
        return basePayHeaderView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "支付"
        
        YX_setUpUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(YX_paySuccess), name: NSNotification.Name(rawValue: YXPAYSUCESS), object: nil)
    }
    
    deinit {
        basePayHeaderView.YX_stopTimer()
        if isCancelOrderBool {
            //取消订单
            basePayViewModel.YX_cancelOrder()
        }
    }
}

extension YXBasePayViewController{
    private func YX_setUpUI(){
        view.addSubview(confirmPaymentBtn)
        confirmPaymentBtn.snp.makeConstraints { (make) in
            make.left.equalTo(view.snp_left)
            make.right.equalTo(view.snp_right)
            make.height.equalTo(74)
            make.bottom.equalTo(view.snp_bottom)
        }
        view.addSubview(payTableView)
        payTableView.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp_top)
            make.left.equalTo(view.snp_left)
            make.right.equalTo(view.snp_right)
            make.bottom.equalTo(confirmPaymentBtn.snp_top)
        }
    }
}

extension YXBasePayViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayDict.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: payCellID, for: indexPath) as! YXBasePayTableViewCell
        cell.YX_cellMessage(iconName: arrayDict[indexPath.row]["icon"]!, titleName: arrayDict[indexPath.row]["name"]!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        confirmPaymentBtn.textColorBool = true
        payWayType = indexPath.row == 0 ? YXPAYWAYTYPE.YXPAY_WECHAT : YXPAYWAYTYPE.YXPAY_ALIPAY
        tableView.deselectRow(at: indexPath, animated: true)
        let cellSel = tableView.cellForRow(at: indexPath) as! YXBasePayTableViewCell
        let array = tableView.visibleCells
        for i in 0..<array.count {
            let cellNor = array[i] as! YXBasePayTableViewCell
            cellNor.choosePayWayImageView.image = UIImage(named: "list_choicebox_nor")
        }
        cellSel.choosePayWayImageView.image = UIImage(named: "list_choicebox_sel")
    }
}

//支付
extension YXBasePayViewController {
    private func YX_confirmPayment(){
        switch payWayType {
        case .YXPAY_WECHAT:
            basePayViewModel.payWay = 0
        default:
            basePayViewModel.payWay = 1
        }
        basePayViewModel.YX_sendPay()
    }
    
    @objc private func YX_paySuccess(){
        basePayHeaderView.YX_stopTimer()
        isCancelOrderBool = false
        let detailVC = YXOrderDetailViewController()
        rt_navigationController.pushViewController(detailVC, animated: true) { (finish) in
            self.rt_navigationController.removeViewController(self)
        }
    }
}
