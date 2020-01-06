//
//  YXLoginTextFieldView.swift
//  youxuan
//
//  Created by 肖锋 on 2019/10/14.
//  Copyright © 2019年 肖锋. All rights reserved.
//

import UIKit

enum nameType : Int{
    case phone = 0
    case code = 1
}

typealias loginTextFieldBlock = (String, NSInteger) ->()

class YXLoginTextFieldView: UIView {
    
    private var time : Int = 60
    
    //保存上一次的文本内容
    private var previousText : String!
    
    //保持上一次的文本范围
    private var previousRange : UITextRange!
    
    private var loginTextFieldBlock : loginTextFieldBlock?
    
    private var timer : Timer?
    
    //获取验证码闭包类型（）->（），无参数，无返回值
    var getCodeBlock : (() -> ())?
    
    private lazy var titleImgeView : UIImageView = {
        let titleImgeView = UIImageView()
        return titleImgeView
    }()
    
    lazy var getCodeButton : UIButton = {
        let getCodeButton = UIButton(type: .custom)
        getCodeButton.setTitle("点击获取", for: .normal)
        getCodeButton.setTitleColor(UIColor.YX_getColor(rgbValue: 0x9B9B9B), for: .normal)
        getCodeButton.titleLabel?.font = UIFont(name: "PingFang-SC-Regular", size: 15.0)
        getCodeButton.addTarget(self, action: #selector(YX_getCodeButtonClick), for: .touchUpInside)
        getCodeButton.isEnabled = false
        return getCodeButton
    }()
    
    private lazy var lineView : UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor.YX_getColor(rgbValue: 0xFFFFFF)
        lineView.layer.cornerRadius = 1.0
        return lineView
    }()

    lazy var loginTextField : YXTextField = {
        let loginTextField = YXTextField()
        loginTextField.clearButtonMode = .whileEditing
        loginTextField.keyboardType = UIKeyboardType.numberPad
        loginTextField.textColor = UIColor.white
        loginTextField.tintColor = UIColor.white
        loginTextField.delegate = self
        loginTextField.font = UIFont(name: "PingFang-SC-Regular", size: 17.0)
        loginTextField.addTarget(self, action: #selector(YX_numberTextChange), for: .editingChanged)
        return loginTextField
    }()
    
    init(frame: CGRect, loginTextFieldBlock: @escaping loginTextFieldBlock, nameType: nameType, titleImageName: String, tag: Int, isHidden: Bool) {
        super.init(frame: frame)
        
        self.loginTextFieldBlock = loginTextFieldBlock
        
        self.backgroundColor = UIColor.YX_getColor(rgbValue: 0xFFFFFF, alpha: 0.5)
        self.layer.cornerRadius = 24.5
        self.isUserInteractionEnabled = true
        
        var nameStr : String = ""
        switch nameType {
        case .phone:
            nameStr = "请输入手机号"
            break
        default:
            nameStr = "请输入验证码"
            break
        }
        let attributedUserPlaceholder = NSAttributedString(string: nameStr, attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        loginTextField.attributedPlaceholder = attributedUserPlaceholder
        loginTextField.tag = tag
        titleImgeView.image = UIImage(named: titleImageName)
        
        YX_addControl(isHidden: isHidden)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//添加控件
extension YXLoginTextFieldView {
    private func YX_addControl(isHidden: Bool){
        self.addSubview(titleImgeView)
        titleImgeView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.snp.centerY)
            make.left.equalTo(self.snp.left).offset(19.0)
            make.width.height.equalTo(24.0)
        }
        
        if isHidden {
            self.addSubview(loginTextField)
            loginTextField.snp.makeConstraints({ (make) in
                make.left.equalTo(titleImgeView.snp.right).offset(19.0)
                make.right.equalTo(snp.right).offset(-15.0)
                make.centerY.equalTo(snp.centerY)
                make.height.equalTo(24.0)
            })
        }else {
            self.addSubview(getCodeButton)
            getCodeButton.snp.makeConstraints { (make) in
                make.right.equalTo(self.snp.right).offset(-15.0)
                make.centerY.equalTo(self.snp.centerY)
                make.width.equalTo(60.0)
                make.height.equalTo(21.0)
            }
            self.addSubview(lineView)
            lineView.snp.makeConstraints { (make) in
                make.right.equalTo(getCodeButton.snp.left).offset(-15.0)
                make.centerY.equalTo(self.snp.centerY)
                make.width.equalTo(2.0)
                make.height.equalTo(20.0)
            }
            
            self.addSubview(loginTextField)
            loginTextField.snp.makeConstraints { (make) in
                make.left.equalTo(titleImgeView.snp.right).offset(19.0)
                make.right.equalTo(lineView.snp.left).offset(-15.0)
                make.centerY.equalTo(self.snp.centerY)
                make.height.equalTo(24.0)
            }
        }
    }
}

//一些监听的方法
extension YXLoginTextFieldView {
    @objc private func YX_getCodeButtonClick(codeButton: UIButton) -> (){
        if getCodeBlock != nil {
            getCodeBlock!()
        }
    }
    
    @objc private func YX_numberTextChange(textField: YXTextField) -> (){
        //只对手机号做处理
        if textField.tag == 100000 {
            let text : String = textField.text!
            //输入的第一位必须是1
            if textField.text != "" && Int(text[0]) != 1 {
                //第1位输入非1数则使用原来值，且关闭停留在开始位置
                textField.text = previousText
                let start = textField.beginningOfDocument
                textField.selectedTextRange = textField.textRange(from: start, to: start)
                return
            }
            //当前光标的位置（后面会对其做修改）
            var cursorPostion = textField.offset(from: textField.beginningOfDocument,
                                                 to: textField.selectedTextRange!.start)
            //过滤掉非数字字符，只保留数字
            let digitsText = getDigitsText(string: textField.text!,
                                           cursorPosition: &cursorPostion)
            //避免超过11位的输入
            if digitsText.count > 11 {
                textField.text = previousText
                textField.selectedTextRange = previousRange
                return
            }
            //得到带有分隔符的字符串
            let hyphenText = getHyphenText(string: digitsText, cursorPosition: &cursorPostion)
            //将最终带有分隔符的字符串显示到textField上
            textField.text = hyphenText
            //让光标停留在正确位置
            let targetPostion = textField.position(from: textField.beginningOfDocument,
                                                   offset: cursorPostion)!
            textField.selectedTextRange = textField.textRange(from: targetPostion,
                                                              to: targetPostion)
            //现在的值和选中范围，供下一次输入使用
            previousText = textField.text!
            previousRange = textField.selectedTextRange!
        }
        //判断闭包是否现实了
        if loginTextFieldBlock != nil {
            loginTextFieldBlock!(textField.text!, textField.tag)
        }
    }
    
    //除去非数字字符，同时确定光标正确位置
    private func getDigitsText(string:String, cursorPosition:inout Int) -> String{
        //保存开始时光标的位置
        let originalCursorPosition = cursorPosition
        //处理后的结果字符串
        var result = ""
        
        var i = 0
        //遍历每一个字符
        for uni in string.unicodeScalars {
            //如果是数字则添加到返回结果中
            if CharacterSet.decimalDigits.contains(uni) {
                result.append(string[i])
            }
                //非数字则跳过，如果这个非法字符在光标位置之前，则光标需要向前移动
            else{
                if i < originalCursorPosition {
                    cursorPosition = cursorPosition - 1
                }
            }
            i = i + 1
        }
        
        return result
    }
    
    //将分隔符插入现在的string中，同时确定光标正确位置
    private func getHyphenText(string:String, cursorPosition:inout Int) -> String {
        //保存开始时光标的位置
        let originalCursorPosition = cursorPosition
        //处理后的结果字符串
        var result = ""
        
        //遍历每一个字符
        for i in 0  ..< string.count  {
            //如果当前到了第4个、第8个数字，则先添加个分隔符
            if i == 3 || i == 7 {
                result.append(" ")
                //如果添加分隔符位置在光标前面，光标则需向后移动一位
                if i < originalCursorPosition {
                    cursorPosition = cursorPosition + 1
                }
            }
            result.append(string[i])
        }
        
        return result
    }
    
    //定时器倒计时
    @objc private func YX_timerChange(){
        time = time - 1
        getCodeButton.setTitle("\(time)s", for: .normal)
        getCodeButton.isEnabled = false
        if time == 0 {
            getCodeButton.setTitle("重新获取", for: .normal)
            getCodeButton.isEnabled = true
            time = 60
            YX_stopTimer()
        }
    }
    //开始定时器
    func YX_startTimer(){
        getCodeButton.isEnabled = false
        timer = Timer(timeInterval: 1, target: self, selector: #selector(YX_timerChange), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: .common)
        timer?.fire()
    }
    
    //销毁定时器
    func YX_stopTimer(){
        time = 60
        timer?.invalidate()
        timer = nil
    }
}

//代理监听,控制输入的位数
extension YXLoginTextFieldView : UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var returnValue : Bool = true
        if textField.tag == 100001{
            if range.location > 5{
                
                returnValue = false
            }
        }
        return returnValue
    }
}


