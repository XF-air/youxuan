//
//  YXLoginViewController.swift
//  youxuan
//
//  Created by 肖锋 on 2019/10/14.
//  Copyright © 2019年 肖锋. All rights reserved.
//

import UIKit
import SnapKit

class YXLoginViewController: YXBaseViewController {
    
    private var phoneNumber : String?
    
    private var codeStr : String?
    
    //创建viewModel
    private var loginViewModel : YXLoginViewModel = YXLoginViewModel()
    
    //背景图片按钮
    private var backgroundImageView : UIImageView = {
        let backgroundImageView = UIImageView(image: UIImage(named: "bg1"))
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.clipsToBounds = true
        backgroundImageView.isUserInteractionEnabled = true
        return backgroundImageView
    }()
    
    private lazy var alphaView : UIView = {
       let alphaView = UIView()
        alphaView.isUserInteractionEnabled = true
        alphaView.backgroundColor = UIColor.YX_getColor(rgbValue: 0x000000, alpha: 0.6)
        return alphaView
    }()
    
    private lazy var iconImageView : UIImageView = {
       let iconImageView = UIImageView(image: UIImage(named: "loginlogo"))
        return iconImageView
    }()
    
    //懒加载电话号码输入框
    private lazy var loginPhoneNumberTextField : YXLoginTextFieldView = {[unowned self] in
        let loginPhoneNumberTextField = YXLoginTextFieldView(frame: CGRect.zero, loginTextFieldBlock: { (text, tag) in
            print("接收到的东西")
            self.phoneNumber = text.replacingOccurrences(of: " ", with: "")
            self.YX_stateCommitBtnAndCodeBtn(text: text, tag: tag)
        }, nameType: .phone, titleImageName: "icon_phone", tag: 100000, isHidden: true)
        return loginPhoneNumberTextField
    }()
    
    //懒加载验证码输入框
    private lazy var loginCodeNumberTextField : YXLoginTextFieldView = { [unowned self] in
        let loginCodeNumberTextField = YXLoginTextFieldView(frame: CGRect.zero, loginTextFieldBlock: { (text, tag) in
            print("这是预留的地方需要处理")
            self.codeStr = text
            self.YX_stateCommitBtnAndCodeBtn(text: text, tag: tag)
        }, nameType: .code, titleImageName: "icon_code", tag:100001, isHidden: false)
        loginCodeNumberTextField.getCodeBlock = {
            self.loginViewModel.phoneNumber = self.phoneNumber
            self.loginViewModel.YX_getCode{
                print("请求回调的结果")
                self.loginCodeNumberTextField.loginTextField.becomeFirstResponder()
            }
        }
        return loginCodeNumberTextField
    }()
    
    private lazy var protocolView : YXProtocolView = { [unowned self] in
        let protocolView = YXProtocolView(frame: CGRect.zero, clickProtocolBlock: {
            self.navigationController?.pushViewController(YXProtocolViewController(), animated: true)
        })
        return protocolView
    }()
    
    private lazy var loginButton : YXButtonView = { [unowned self] in
        let loginButton = YXButtonView(frame: CGRect.zero, titleText: "登录", isWhiteBool: false, clickBlock: {
            print("请求登录")
            self.loginViewModel.code = self.codeStr
            self.loginViewModel.YX_requestLogin{
                guard let resultBool = self.loginViewModel.resultBool else { return }
                if resultBool {
                    print("跳转到添加商铺的页面")
                    //跳转到添加商铺的页面
                    let addShoppVC = YXAddShoppMessageViewController()
                    addShoppVC.navigationItem.title = "添加商铺"
                    addShoppVC.phoneNumber = self.phoneNumber!.replacingOccurrences(of: " ", with: "")
                    self.navigationController?.pushViewController(addShoppVC, animated: true)
                }else {
                    print("回到首页")
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: YXREFERSHMINENOTIFICATION), object: nil)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: YXRECEIVEDLOCATIONNOTIFICATION), object: nil)
                    self.navigationController?.popToRootViewController(animated: true)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                        MainTabBarController().cyl_popSelectTabBarChildViewController(at: 0, animated: true)
                    }
                }
            }
        })
        loginButton.textColorBool = false
        return loginButton
    }()
    
    //设置状态栏字体颜色
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        loginViewModel.delegate = self
        
        YX_setUpBackgroundMessage()
        
//        YX_overrideNavReturnBtn()
        
        YX_setUpContentControl()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //这里做测试使用,移除token
        YXUserDefulatTools.YX_removeUserDefult()
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        loginPhoneNumberTextField.loginTextField.resignFirstResponder()
        loginCodeNumberTextField.loginTextField.resignFirstResponder()
    }
    
    private func YX_stateCommitBtnAndCodeBtn(text: String, tag: Int){
        //判断获取验证码的按钮状态
        if tag == 100000 {
            if text.count >= 13 {
                loginCodeNumberTextField.getCodeButton.isEnabled = true
                loginCodeNumberTextField.getCodeButton.setTitleColor(UIColor.YX_getColor(rgbValue: 0xFFFFFF), for: .normal)
                phoneNumber = text
            }else{
                loginCodeNumberTextField.getCodeButton.setTitle("点击获取", for: .normal)
                loginCodeNumberTextField.getCodeButton.isEnabled = false
                loginCodeNumberTextField.getCodeButton.setTitleColor(UIColor.YX_getColor(rgbValue: 0x999999), for: .normal)
                loginCodeNumberTextField.YX_stopTimer()
            }
        }
        if ((phoneNumber?.count)! < 13) || (codeStr?.count != 6) {
            loginButton.textColorBool = false
            return
        }else {
            loginButton.textColorBool = true
        }
    }
    
    //调用系统的方法，查看页面是否销毁
    deinit {
        print("页面销毁")
    }
}

extension YXLoginViewController {
    //添加背景图片和图片相关设置
    private func YX_setUpBackgroundMessage() {
        view.addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        backgroundImageView.addSubview(alphaView)
        alphaView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private func YX_setUpContentControl(){
        alphaView.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { (make) in
            make.top.equalTo(alphaView.snp.top).offset(105.0)
            make.centerX.equalTo(alphaView.snp.centerX)
            make.width.height.equalTo(84.0)
        }
        
        alphaView.addSubview(loginPhoneNumberTextField)
        loginPhoneNumberTextField.snp.makeConstraints { (make) in
            make.left.equalTo(alphaView.snp.left).offset(15.0)
            make.right.equalTo(alphaView.snp.right).offset(-15.0)
            make.height.equalTo(49.0)
            make.top.equalTo(iconImageView.snp.bottom).offset(84.0)
        }
        
        alphaView.addSubview(loginCodeNumberTextField)
        loginCodeNumberTextField.snp.makeConstraints { (make) in
            make.left.equalTo(loginPhoneNumberTextField.snp.left)
            make.right.equalTo(loginPhoneNumberTextField.snp.right)
            make.height.equalTo(loginPhoneNumberTextField.snp.height)
            make.top.equalTo(loginPhoneNumberTextField.snp.bottom).offset(30.0)
        }
        alphaView.addSubview(protocolView)
        protocolView.snp.makeConstraints { (make) in
            make.bottom.equalTo(alphaView.snp.bottom).offset(-20)
            make.width.equalTo(310.0)
            make.height.equalTo(17.0)
            make.centerX.equalTo(alphaView.snp.centerX)
        }
        
        alphaView.addSubview(loginButton)
        loginButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(protocolView.snp.top)
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
            make.height.equalTo(74.0)
        }
    }
}

//重写导航条返回按钮
extension YXLoginViewController {
//    private func YX_overrideNavReturnBtn(){
//        let returnButton = UIButton(type: .custom)
//        returnButton.setImage(UIImage(named: "icon_nav_back1"), for: .normal)
//        returnButton.adjustsImageWhenHighlighted = false
//        returnButton.addTarget(self, action: #selector(yx_returnButtonClick), for: .touchUpInside)
//        alphaView.addSubview(returnButton)
//        returnButton.snp.makeConstraints { (make) in
//            make.left.equalTo(alphaView.snp.left).offset(15.0)
//            make.top.equalTo(alphaView.snp.top).offset(28.0)
//            make.width.height.equalTo(24.0)
//        }
//    }
//
//    @objc func yx_returnButtonClick(){
//        navigationController?.popViewController(animated: true)
//    }
}

//实现代理方法
extension YXLoginViewController : YXLoginViewModelDelegate {
    func YXLoginViewModelDelegate() {
        loginCodeNumberTextField.YX_startTimer()
        //这里需要根据
    }
}


