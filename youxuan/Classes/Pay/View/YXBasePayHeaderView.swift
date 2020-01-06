//
//  YXBasePayHeaderView.swift
//  youxuan
//
//  Created by 肖锋 on 2019/11/25.
//  Copyright © 2019 肖锋. All rights reserved.
//

import UIKit

class YXBasePayHeaderView: UIView {
    
    private var timeRemaining : Int = 0
    
    var basePayModel : YXBasePayModel? {
        didSet{
           guard let basePayModel = basePayModel else {return}
            moneyLabel.text = basePayModel.orderAmt
            timeRemaining = basePayModel.timeRemaining
            YX_addTimer()
        }
    }
    
    private lazy var moneyLabel : UILabel = {
        let moneyLabel = UILabel()
        moneyLabel.textAlignment = .center
        moneyLabel.font = UIFont(name: "PingFang-SC-Medium", size: 35)
        moneyLabel.textColor = UIColor.YX_getColor(rgbValue: 0x000000)
        return moneyLabel
    }()
    
    private lazy var timContentLabel : UILabel = {
        let timContentLabel = UILabel()
        timContentLabel.textAlignment = .right
        timContentLabel.font = UIFont(name: "PingFang-SC-Semibold", size: 15)
        timContentLabel.textColor = UIColor.YX_getColor(rgbValue: 0xF39C13)
        return timContentLabel
    }()
    
    private var timerOutBlock : (() -> ())?
    
    private lazy var payTimer : Timer = {
        let payTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(YX_timerCount), userInfo: nil, repeats: true)
        RunLoop.current.add(payTimer, forMode: .common)
        return payTimer
    }()
    
    init(frame: CGRect, timerOutBlock: (() -> ())?) {
        super.init(frame: frame)
        self.timerOutBlock = timerOutBlock
        
        let timeView = UIView()
        timeView.backgroundColor = UIColor.YX_getColor(rgbValue: 0xF5F5F5)
        timeView.layer.cornerRadius = 17
        addSubview(timeView)
        timeView.snp.makeConstraints { (make) in
            make.top.equalTo(snp_top).offset(40)
            make.centerX.equalTo(snp_centerX)
            make.height.equalTo(34)
            make.width.equalTo(185)
        }
        
        let timLabel = UILabel()
        timLabel.text = "支付剩余时间"
        timLabel.textAlignment = .left
        timLabel.font = UIFont(name: "PingFang-SC-Regular", size: 15)
        timLabel.textColor = UIColor.YX_getColor(rgbValue: 0x4A4A4A)
        timeView.addSubview(timLabel)
        timLabel.snp.makeConstraints { (make) in
            make.left.equalTo(timeView.snp_left).offset(15)
            make.centerY.equalTo(timeView.snp_centerY)
        }
        
        timeView.addSubview(timContentLabel)
        timContentLabel.snp.makeConstraints { (make) in
            make.right.equalTo(timeView.snp_right).offset(-15)
            make.centerY.equalTo(timeView.snp_centerY)
        }
        
        addSubview(moneyLabel)
        moneyLabel.snp.makeConstraints { (make) in
            make.top.equalTo(timeView.snp_bottom).offset(40)
            make.centerX.equalTo(timeView.snp_centerX)
        }
        
        let moneySymbolLabel = UILabel()
        moneySymbolLabel.text = "¥"
        moneySymbolLabel.textAlignment = .right
        moneySymbolLabel.font = UIFont(name: "PingFang-SC-Regular", size: 18)
        moneySymbolLabel.textColor = UIColor.YX_getColor(rgbValue: 0x000000)
        addSubview(moneySymbolLabel)
        moneySymbolLabel.snp.makeConstraints { (make) in
            make.right.equalTo(moneyLabel.snp_left).offset(-5)
            make.bottom.equalTo(moneyLabel.snp_bottom).offset(-7)
        }
        
        let amountPayLabel = UILabel()
        amountPayLabel.text = "待支付金额"
        amountPayLabel.textAlignment = .center
        amountPayLabel.font = UIFont(name: "PingFang-SC-Regular", size: 15)
        amountPayLabel.textColor = UIColor.YX_getColor(rgbValue: 0xB4B4B4)
        addSubview(amountPayLabel)
        amountPayLabel.snp.makeConstraints { (make) in
            make.top.equalTo(moneyLabel.snp_bottom)
            make.centerX.equalTo(moneyLabel.snp_centerX)
        }
        
        let titleLabel = UILabel()
        titleLabel.text = "支付方式"
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont(name: "PingFang-SC-Medium", size: 15)
        titleLabel.textColor = UIColor.YX_getColor(rgbValue: 0x4A4A4A)
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(snp_bottom).offset(-15)
            make.left.equalTo(snp_left).offset(15)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//添加定时器
extension YXBasePayHeaderView {
    private func YX_addTimer(){
        YX_startTimer()
    }
    
    //开始计时
    private func YX_startTimer(){
        payTimer.fire()
    }
    
    //结束计时
    func YX_stopTimer(){
        payTimer.invalidate()
    }
}

//监听
extension YXBasePayHeaderView {
    @objc private func YX_timerCount(){
        timeRemaining = timeRemaining - 1
        timContentLabel.text = YXBaseTools.YX_getMMSSFromSS(totalTime: timeRemaining)
        if timeRemaining <= 0 {
            YX_stopTimer()
            if timerOutBlock != nil {
                timerOutBlock!()
            }
        }
    }
}
