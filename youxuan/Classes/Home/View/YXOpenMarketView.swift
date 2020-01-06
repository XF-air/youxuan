//
//  YXOpenMarketView.swift
//  youxuan
//
//  Created by 肖锋 on 2019/11/8.
//  Copyright © 2019 肖锋. All rights reserved.
//

import UIKit

class YXOpenMarketView: UIView {
    
    var goodsModel : YXGoodsModel?{
        didSet {
            guard let goodsModel = goodsModel else { return }
            //在这里设置定时器
            YX_startTimer(timeCount: goodsModel.timeRemaining)
        }
    }
    
    
    //倒计时结束的回调
    var openMarketTimeOutBlock : (() -> ())?
    
    private lazy var lineView : UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor.YX_getColor(rgbValue: 0xEEF0F3)
        return lineView
    }()
    
    private lazy var timeLabel : UILabel = {
        let timeLabel = UILabel()
        timeLabel.text = "距开市"
        timeLabel.textAlignment = .left
        timeLabel.font = UIFont(name: "PingFang-SC-Medium", size: 18)
        timeLabel.textColor = UIColor.YX_getColor(rgbValue: 0x4A4A4A)
        return timeLabel
    }()
    
    private lazy var imageView : UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "icon_time"))
        return imageView
    }()
    
    private lazy var htimeLabel : UILabel = {
        let htimeLabel = UILabel()
        htimeLabel.text = "00"
        htimeLabel.textAlignment = .center
        htimeLabel.font = UIFont(name: "PingFang-SC-Semibold", size: 13.2)
        htimeLabel.textColor = UIColor.YX_getColor(rgbValue: 0xFFFFFF)
        htimeLabel.backgroundColor = UIColor.YX_getColor(rgbValue: 0xFF1944)
        htimeLabel.layer.cornerRadius = 1.5
        htimeLabel.clipsToBounds = true
        return htimeLabel
    }()
    
    private lazy var hcolonLabel : UILabel = {
        let hcolonLabel = UILabel()
        hcolonLabel.text = ":"
        hcolonLabel.textColor = UIColor.YX_getColor(rgbValue: 0xFF1944)
        return hcolonLabel
    }()
    
    private lazy var mtimeLabel : UILabel = {
        let mtimeLabel = UILabel()
        mtimeLabel.text = "00"
        mtimeLabel.textAlignment = .center
        mtimeLabel.font = UIFont(name: "PingFang-SC-Semibold", size: 13.2)
        mtimeLabel.textColor = UIColor.YX_getColor(rgbValue: 0xFFFFFF)
        mtimeLabel.backgroundColor = UIColor.YX_getColor(rgbValue: 0xFF1944)
        mtimeLabel.layer.cornerRadius = 1.5
        mtimeLabel.clipsToBounds = true
        return mtimeLabel
    }()
    
    private lazy var mcolonLabel : UILabel = {
        let mcolonLabel = UILabel()
        mcolonLabel.text = ":"
        mcolonLabel.textColor = UIColor.YX_getColor(rgbValue: 0xFF1944)
        return mcolonLabel
    }()
    
    private lazy var stimeLabel : UILabel = {
        let stimeLabel = UILabel()
        stimeLabel.text = "00"
        stimeLabel.textAlignment = .center
        stimeLabel.font = UIFont(name: "PingFang-SC-Semibold", size: 13.2)
        stimeLabel.textColor = UIColor.YX_getColor(rgbValue: 0xFFFFFF)
        stimeLabel.backgroundColor = UIColor.YX_getColor(rgbValue: 0xFF1944)
        stimeLabel.layer.cornerRadius = 1.5
        stimeLabel.clipsToBounds = true
        return stimeLabel
    }()
    
    init(frame: CGRect, openMarketTimeOutBlock: (() -> ())?) {
        super.init(frame: frame)
        
        self.openMarketTimeOutBlock = openMarketTimeOutBlock
        
        YX_setUpUI()
        
        backgroundColor = UIColor.white
        
        self.layer.mask = YXBaseTools.YX_configRectCorner(view: self, corner: [.topRight, .topLeft], cornerRadii: CGSize(width: 10, height: 10))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

//添加控件
extension YXOpenMarketView {
    private func YX_setUpUI(){
        addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.left.equalTo(snp_left)
            make.right.equalTo(snp_right)
            make.height.equalTo(0.5)
            make.bottom.equalTo(snp_bottom).offset(-10)
        }
        
        addSubview(timeLabel)
        timeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(snp_top).offset(10)
            make.left.equalTo(snp_left).offset(10)
        }
        
        addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(timeLabel.snp_centerY)
            make.left.equalTo(timeLabel.snp_right).offset(5)
            make.height.width.equalTo(24)
        }
        
        addSubview(htimeLabel)
        htimeLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(timeLabel.snp_centerY)
            make.height.equalTo(16)
            make.width.equalTo(18)
            make.left.equalTo(imageView.snp_right).offset(5)
        }
        
        addSubview(hcolonLabel)
        hcolonLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(timeLabel.snp_centerY)
            make.left.equalTo(htimeLabel.snp_right).offset(2)
        }
        
        addSubview(mtimeLabel)
        mtimeLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(timeLabel.snp_centerY)
            make.height.equalTo(16)
            make.width.equalTo(18)
            make.left.equalTo(hcolonLabel.snp_right).offset(2)
        }
        
        addSubview(mcolonLabel)
        mcolonLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(timeLabel.snp_centerY)
            make.left.equalTo(mtimeLabel.snp_right).offset(2)
        }
        
        addSubview(stimeLabel)
        stimeLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(timeLabel.snp_centerY)
            make.height.equalTo(16)
            make.width.equalTo(18)
            make.left.equalTo(mcolonLabel.snp_right).offset(2)
        }
    }
}

extension YXOpenMarketView {
    private func YX_startTimer(timeCount: Int) {
        var timeCount = timeCount
        let timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
        timer.schedule(deadline: .now(), repeating: .seconds(1))
        timer.setEventHandler {
            timeCount = timeCount - 1
            DispatchQueue.main.async {
                let time = YXBaseTools.YX_getMMSSFromSSWithRemaining(totalTime: timeCount)
                let timeArray : Array = time.components(separatedBy: ":")
                self.htimeLabel.text = timeArray[0]
                self.mtimeLabel.text = timeArray[1]
                self.stimeLabel.text = timeArray[2]
            }
            if timeCount <= 0 {
                timer.cancel()
                //返回主线程请求数据
                DispatchQueue.main.async {
                    if self.openMarketTimeOutBlock != nil {
                        self.openMarketTimeOutBlock!()
                    }
                }
            }
            
        }
        timer.resume()
    }
}


