//
//  YXReceivingAddressViewController.swift
//  youxuan
//
//  Created by 肖锋 on 2019/10/23.
//  Copyright © 2019 肖锋. All rights reserved.
//

import UIKit

private let cellID = "cellID"

class YXReceivingAddressViewController: YXBaseViewController {
    
    private lazy var tableview : UITableView = {
        let tableview = UITableView(frame: CGRect.zero, style: .plain)
        tableview.separatorStyle = .none
        tableview.delegate = self
        tableview.dataSource = self
        tableview.showsVerticalScrollIndicator = false
        tableview.showsHorizontalScrollIndicator = false
        tableview.rowHeight = 78
        tableview.register(YXAddressTableViewCell.self, forCellReuseIdentifier: cellID)
        return tableview
    }()
    
    private lazy var addRessBtn : YXButtonView = {
        let addRessBtn = YXButtonView(frame: CGRect.zero, titleText: "添加收货地址", isWhiteBool: true) {
            
        }
        addRessBtn.textColorBool = true
        return addRessBtn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white

        navigationItem.title = "收货地址"
        
        YX_setUpUI()
    }
}

extension YXReceivingAddressViewController {
    private func YX_setUpUI(){
        view.addSubview(addRessBtn)
        addRessBtn.snp.makeConstraints { (make) in
            make.left.equalTo(view.snp_left)
            make.right.equalTo(view.snp_right)
            make.height.equalTo(74)
            make.bottom.equalTo(view.snp_bottom)
        }
        view.addSubview(tableview)
        tableview.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp_top).offset(15)
            make.left.equalTo(view.snp_left)
            make.right.equalTo(view.snp_right)
            make.bottom.equalTo(addRessBtn.snp_top)
        }
    }
}

extension YXReceivingAddressViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! YXAddressTableViewCell
        cell.backgroundColor = UIColor.YX_getRandomColor()
        return cell
    }
}
