//
//  YXAddShoppMessageViewController.swift
//  youxuan
//
//  Created by 肖锋 on 2019/10/17.
//  Copyright © 2019 肖锋. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import TZImagePickerController

private let shoppTableViewCell = "YXAddShoppTableViewCell"
private let YXFooterH : CGFloat = 201

enum YXSTATES {
    case YXLOGINTYPE
    case YXMINETYPE
}
class YXAddShoppMessageViewController: YXBaseViewController {
    
    var states = YXSTATES.YXLOGINTYPE
    
    var updateBlock : (() -> ())?
    
    
    //定义商铺名称的数组
    var addShopTitleArray = [
                            "商铺名：",
                            "联系人：",
                            "手机号：",
                            "所在地区：",
                            "详细地址：",
                            "邀请码："
                            ]
    //定义占位文字
    var placeholderLabelArray = [
                            "请输入商铺名",
                            "请输入联系人姓名",
                            "请输入手机号",
                            "请选择省市区",
                            "请输入详细地址",
                            "请输入邀请码"
                            ]
    
    private lazy var addShoppViewModel : YXAddShoppViewModel = YXAddShoppViewModel()
    
    private lazy var chooseArealModel : YXChooseAreaModel = YXChooseAreaModel()
    
    private var addTitleAddressView = YXAddTitleAddressView()
    
    //懒加载一个数组
    private lazy var dataArray : NSMutableArray = NSMutableArray()
    
    var phoneNumber, shopName, name, address, invitationCode : String?
    
    var intTag : Int?
    
    var businessLicenseImage, shopFrontImage : UIImage?
    
    //懒加载tableView属性
    private lazy var shoppTableView : UITableView = { [unowned self] in
        let shoppTableView = UITableView(frame: CGRect.zero, style: .plain)
        shoppTableView.separatorStyle = .none
        shoppTableView.rowHeight = 59
        shoppTableView.dataSource = self
        shoppTableView.register(YXAddShoppTableViewCell.self, forCellReuseIdentifier: shoppTableViewCell)
        shoppTableView.backgroundColor = UIColor.white
        shoppTableView.tableFooterView = addShoppFooterView
        shoppTableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(YX_touchTableView)))
        return shoppTableView
    }()
    
    //添加按钮
    private lazy var commitBtn : YXButtonView = {
        let commitBtn = YXButtonView(frame: CGRect.zero, titleText: "提交", isWhiteBool: true) { [unowned self] in
            switch self.states {
            case .YXLOGINTYPE:
                self.YX_addShoppToatlFunc()
            case .YXMINETYPE:
                self.YX_modifyShopTotalFunc()
            }
        }
        commitBtn.textColorBool = true
        return commitBtn
    }()
    
    //懒加载footer
    private lazy var addShoppFooterView : YXAddShoppFooterView = { [unowned self] in
        let addShoppFooterView = YXAddShoppFooterView(frame: CGRect(x: 0, y: 0, width: YXScreenW, height: YXFooterH), addShopBlock: { (tag) in
            self.intTag = tag
            //查询是否通过了验证
            self.YX_setCameraPermissions()
        }) { (tag) in
            self.YX_deletePhotos(tag: tag)
        }
        return addShoppFooterView
    }()
    
    private lazy var imagePickerVc : UIImagePickerController = {
        let imagePickerVc = UIImagePickerController()
        imagePickerVc.delegate = self
        imagePickerVc.allowsEditing = true
        imagePickerVc.sourceType = .camera
        imagePickerVc.navigationBar.barTintColor = self.navigationController?.navigationBar.barTintColor
        imagePickerVc.navigationBar.tintColor = self.navigationController?.navigationBar.tintColor
        return imagePickerVc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
        YX_setUpShoppBusiness()
        
        switch states {
        case .YXLOGINTYPE:
            YX_jumptoLoginVC()
        case .YXMINETYPE:
            //这里表示是从我的里面进来的
            YX_pushSelfOfMineVC()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        shoppTableView.endEditing(true)
    }
}

//添加商铺总的判断和方法
extension YXAddShoppMessageViewController {
    private func YX_addShoppToatlFunc(){
        if chooseArealModel.shopName.count == 0 {
            YXMBProgressHUDTools.YX_presentHudWithMessage(message: "请输入商铺名")
            return
        }else if chooseArealModel.name.count == 0 {
            YXMBProgressHUDTools.YX_presentHudWithMessage(message: "请输入联系人姓名")
            return
        }else if chooseArealModel.districtCode.count == 0 {
            YXMBProgressHUDTools.YX_presentHudWithMessage(message: "请选择省市区")
            return
        }else if chooseArealModel.address.count == 0 {
            YXMBProgressHUDTools.YX_presentHudWithMessage(message: "请输入详细地址")
            return
        }else if addShoppViewModel.configVal == "1" && self.chooseArealModel.invitationCode.count == 0 {
            YXMBProgressHUDTools.YX_presentHudWithMessage(message: "请输入邀请码")
            return
        }else if businessLicenseImage == nil {
            YXMBProgressHUDTools.YX_presentHudWithMessage(message: "请上传营业执照")
            return
        }else if shopFrontImage == nil {
            YXMBProgressHUDTools.YX_presentHudWithMessage(message: "请上传门头照片")
            return
        }
        addShoppViewModel.chooseArealModel = chooseArealModel
        dataArray.removeAllObjects()
        dataArray.addObjects(from: [businessLicenseImage as Any, shopFrontImage as Any])
        addShoppViewModel.YX_upLoadPictures(dataArray: dataArray) {
            //刷新我的页面中的内容
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: YXREFERSHMINENOTIFICATION), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: YXRECEIVEDLOCATIONNOTIFICATION), object: nil)
            self.rt_navigationController.popToRootViewController(animated: true, complete: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                MainTabBarController().cyl_popSelectTabBarChildViewController(at: 0, animated: true)
            }
        }
    }
}

//修改商铺总的判断和方法
extension YXAddShoppMessageViewController {
    private func YX_modifyShopTotalFunc(){
        let shopName = chooseArealModel.shopName.count == 0 ? addShoppViewModel.mineModel.businessName : chooseArealModel.shopName
        let name = chooseArealModel.name.count == 0 ? addShoppViewModel.mineModel.name : chooseArealModel.name
        let districtCode = chooseArealModel.districtCode.count == 0 ? addShoppViewModel.mineModel.areaCode : chooseArealModel.districtCode
        let address = chooseArealModel.address.count == 0 ? addShoppViewModel.mineModel.address : chooseArealModel.address
        if shopName.count == 0 {
            YXMBProgressHUDTools.YX_presentHudWithMessage(message: "请输入商铺名")
            return
        }else if name.count == 0 {
            YXMBProgressHUDTools.YX_presentHudWithMessage(message: "请输入联系人姓名")
            return
        }else if districtCode.count == 0 {
            YXMBProgressHUDTools.YX_presentHudWithMessage(message: "请选择省市区")
            return
        }else if address.count == 0 {
            YXMBProgressHUDTools.YX_presentHudWithMessage(message: "请输入详细地址")
            return
        }
        addShoppViewModel.YX_requestModifyShopMessage(businessName: shopName, name: name, districtCode: districtCode, address: address) {
            self.rt_navigationController.popViewController(animated: true) { (bool) in
                if self.updateBlock != nil {
                    self.updateBlock!()
                }
            }
        }
    }
}

//从我的里面进来的
extension YXAddShoppMessageViewController {
    private func YX_pushSelfOfMineVC(){
        addShopTitleArray.removeLast()
        placeholderLabelArray.removeLast()
        addShopTitleArray[3] = "收货地："
        addShopTitleArray[4] = "门牌号："
        
        addShoppViewModel.YX_requestBusinessMessage {
            self.addShoppFooterView.mineModel = self.addShoppViewModel.mineModel
            self.addTitleAddressView.title = "修改地址"
            self.addTitleAddressView.type = SHP_ADDRESS_MINETYPE
            self.addTitleAddressView.typeCode = SHP_CODE_AREA
            self.addTitleAddressView.code = self.addShoppViewModel.mineModel.cityCode
            self.addTitleAddressView.delegate1 = self
            self.addTitleAddressView.defaultHeight = 400
            self.addTitleAddressView.titleScrollViewH = 30
            self.view.addSubview(self.addTitleAddressView.yx_initAddressView())
            
            self.shoppTableView.reloadData()
        }
    }
}


//区分是从我的里面跳进来的,还是从登录页面跳进来的
extension YXAddShoppMessageViewController {
    private func YX_jumptoLoginVC(){
        
        YX_checkInvitationCode()
        addTitleAddressView.title = "选择地址"
        addTitleAddressView.type = SHP_ADDRESS_OTHERTYP
        addTitleAddressView.typeCode = SHP_CODE_PROVINCE
        addTitleAddressView.code = " "
        addTitleAddressView.delegate1 = self;
        addTitleAddressView.defaultHeight = 400
        addTitleAddressView.titleScrollViewH = 30
        self.view.addSubview(addTitleAddressView.yx_initAddressView())
    }
}

//实现地区选择器的代理方法
extension YXAddShoppMessageViewController : YXAddTitleAddressViewDelegate {
    func cancelBtnClick(_ titleAddress: String!, titleID: String!, adcode adCode: String!, city: String!) {
        switch states {
        case .YXLOGINTYPE:
            chooseArealModel.areaStr = titleAddress
            chooseArealModel.districtCode = titleID
            chooseArealModel.city = city
            chooseArealModel.adCode = adCode
        default:
            chooseArealModel.areaStr = titleAddress
            chooseArealModel.districtCode = titleID
        }
        shoppTableView.reloadRows(at: [IndexPath(row: 3, section: 0)], with: .none)
    }
}

//移除delete
extension YXAddShoppMessageViewController {
    private func YX_deletePhotos(tag: Int) {
        switch tag {
        case 20000:
            self.addShoppFooterView.businessLicenseView.chooseImageView.isHidden = true
            self.addShoppFooterView.businessLicenseView.deletaBtn.isHidden = true
            self.addShoppFooterView.businessLicenseView.contentImageView.isHidden = false
            self.addShoppFooterView.businessLicenseView.titleContentView.isHidden = false
        default:
            self.addShoppFooterView.doorPhotosView.chooseImageView.isHidden = true
            self.addShoppFooterView.doorPhotosView.deletaBtn.isHidden = true
            self.addShoppFooterView.doorPhotosView.contentImageView.isHidden = false
            self.addShoppFooterView.doorPhotosView.titleContentView.isHidden = false
        }
    }
}

//查询邀请码是不是必须传的参数
extension YXAddShoppMessageViewController {
    private func YX_checkInvitationCode(){
        addShoppViewModel.YX_requestInvitationCode {
            switch self.addShoppViewModel.configVal {
            case "1":
                self.placeholderLabelArray[5] = "请输入邀请码(必填)"
            default://这里表示是0 不必填
                self.placeholderLabelArray[5] = "请输入邀请码(不必填)"
            }
            self.shoppTableView.reloadData()
        }
    }
}

//添加控件
extension YXAddShoppMessageViewController {
    private func YX_setUpShoppBusiness(){
        
        view.addSubview(shoppTableView)
        shoppTableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.top).offset(15)
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
            make.bottom.equalTo(self.view.snp.bottom).offset(-74)
        }
        
        view.addSubview(commitBtn)
        commitBtn.snp.makeConstraints { (make) in
           make.height.equalTo(74)
           make.left.equalTo(self.view.snp.left)
           make.right.equalTo(self.view.snp.right)
           make.bottom.equalTo(self.view.snp.bottom)
        }
    }
}

//数据源方法
extension YXAddShoppMessageViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addShopTitleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let shoppCell = tableView.dequeueReusableCell(withIdentifier: shoppTableViewCell, for: indexPath) as! YXAddShoppTableViewCell
        shoppCell.titleName = addShopTitleArray[indexPath.row]
        shoppCell.placeholder = placeholderLabelArray[indexPath.row]
        shoppCell.textTag = 10000 + indexPath.row
        if indexPath.row == 2 || indexPath.row == 5 {
            //将手机号传给里面
            if indexPath.row == 2 {
                switch states {
                case .YXLOGINTYPE:
                    shoppCell.phoneNumber = phoneNumber
                case .YXMINETYPE:
                    shoppCell.baseCellContentView.textField.isHidden = true
                    shoppCell.arrorImageView.isHidden = false
                    shoppCell.areaLabel.isHidden = false
                }
            }
            shoppCell.keyboardType = .numberPadKey
        }else {
            shoppCell.keyboardType = .defaultKey
        }
        if indexPath.row == 3 {
            shoppCell.arrorImageView.isHidden = false
            shoppCell.areaLabel.isHidden = false
            shoppCell.baseCellContentView.textField.isHidden = true
            
            if chooseArealModel.areaStr.count != 0 {
                shoppCell.areaLabel.text = chooseArealModel.areaStr
                shoppCell.areaLabel.textColor = UIColor.YX_getColor(rgbValue: 0x32312D)
            }
        }
        if states == .YXMINETYPE && addShoppViewModel.businessArrayM.count != 0 {
            switch indexPath.row {
            case 0:
                shoppCell.baseCellContentView.textField.text = (addShoppViewModel.businessArrayM[indexPath.row] as! YXMineModel).businessName
            case 1:
                shoppCell.baseCellContentView.textField.text = (addShoppViewModel.businessArrayM[indexPath.row] as! YXMineModel).name
            case 2:
                shoppCell.areaLabelText = (addShoppViewModel.businessArrayM[indexPath.row] as! YXMineModel).mobile
            case 3:
                let province = (addShoppViewModel.businessArrayM[indexPath.row] as! YXMineModel).province
                let city = (addShoppViewModel.businessArrayM[indexPath.row] as! YXMineModel).city
                let area = chooseArealModel.areaStr.count != 0 ? chooseArealModel.areaStr : (addShoppViewModel.businessArrayM[indexPath.row] as! YXMineModel).area
                shoppCell.areaLabel.text = "\(province) \(city) \(area)"
                shoppCell.areaLabel.textColor = UIColor.YX_getColor(rgbValue: 0x32312D)
            default:
                shoppCell.baseCellContentView.textField.text = (addShoppViewModel.businessArrayM[indexPath.row] as! YXMineModel).address
                break
            }
        }
        //cell中输入框的监听
        shoppCell.baseCellContentView.textField.addTarget(self, action: #selector(YX_cellTextEditChange), for: .editingChanged)
        shoppCell.areaLabelBlock = {
            print("indexPath.row:\(indexPath.row)")
            switch indexPath.row {
            case 2:
                let changePhoneVC = YXChangePhoneNumberViewController()
                changePhoneVC.navigationItem.title = "旧手机号验证"
                self.rt_navigationController.pushViewController(changePhoneVC, animated: true, complete: nil)
            case 3:
                self.YX_presentAlreatAreaView()
            default:
                break
            }
        }
        return shoppCell
    }
}

//弹出地区选择器
extension YXAddShoppMessageViewController {
    private func YX_presentAlreatAreaView(){
        print("---------弹出地区选择器的view---------")
        shoppTableView.endEditing(true)
        addTitleAddressView.addAnimate()
    }
}

//监听
extension YXAddShoppMessageViewController {
    @objc private func YX_cellTextEditChange(textField: UITextField){
        print("text的tag:\(textField.tag)")
        switch textField.tag {
        case 10000:
            chooseArealModel.shopName = textField.text!
        case 10001:
            chooseArealModel.name = textField.text!
        case 10004:
            chooseArealModel.address = textField.text!
        case 10005:
            chooseArealModel.invitationCode = textField.text!
        default: break
        }
    }
    
    @objc private func YX_touchTableView(){
        shoppTableView.endEditing(true)
    }
}

//验证是否可以打开照相机
extension YXAddShoppMessageViewController {
    private func YX_setCameraPermissions(){
        
        let authStatus = AVCaptureDevice.authorizationStatus(for: .video)
        if authStatus == .restricted || authStatus == .denied {
            YX_alreatView(title: "无法使用相机", detailTitle: "请在iPhone的 设置-隐私-相机 中允许访问相机")
        }else if authStatus == .notDetermined {
            AVCaptureDevice.requestAccess(for: .video) { (granted) in
                if granted {
                    DispatchQueue.global().async {
                        self.YX_setCameraPermissions()
                    }
                }
            }
        }else if PHPhotoLibrary.authorizationStatus().rawValue == 2 {// 已被拒绝，没有相册权限，将无法保存拍的照片
            YX_alreatView(title: "无法访问相册", detailTitle: "请在iPhone的 设置-隐私-相机 中允许访问相机")
        }else if PHPhotoLibrary.authorizationStatus().rawValue == 0 {// 未请求过相册权限
            TZImageManager.default()?.requestAuthorization(completion: {
                self.YX_setCameraPermissions()
            })
        }else {
            YX_presentImageVC()
        }
        
    }
}

//提示
extension YXAddShoppMessageViewController {
    private func YX_alreatView(title: String, detailTitle: String) {
        let cameraPermissionsAlreatView = YXAlreatView(frame: CGRect(x: 30, y: 0, width: YXScreenW - 60, height: 214), title: title, detailTitle: detailTitle, sureBtnTitle: "确定", sureBlock: {
            if UIApplication.shared.canOpenURL(URL(string: UIApplication.openSettingsURLString)!) {
                UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
            }
            self.zh_popupController.fadeDismiss()
        }) {
            self.zh_popupController.fadeDismiss()
        }
        self.zh_popupController = zh_popupController
        self.zh_popupController.dismissOnMaskTouched = false
        self.zh_popupController.presentContentView(cameraPermissionsAlreatView)
    }
}

//访问照相机
extension YXAddShoppMessageViewController {
    private func YX_presentImageVC(){
        self.present(imagePickerVc, animated: true, completion: nil)
    }
}

//代理方法的实现
extension YXAddShoppMessageViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePickerVc.dismiss(animated: true) {
            let editedImage = info[.editedImage] as! UIImage
            switch self.intTag {
            case 10000:
                self.businessLicenseImage = editedImage
                self.addShoppFooterView.businessLicenseView.chooseImageView.isHidden = false
                self.addShoppFooterView.businessLicenseView.deletaBtn.isHidden = false
                self.addShoppFooterView.businessLicenseView.contentImageView.isHidden = true
                self.addShoppFooterView.businessLicenseView.titleContentView.isHidden = true
                self.addShoppFooterView.businessLicenseView.chooseImageView.image = editedImage
            default:
                self.shopFrontImage = editedImage
                self.addShoppFooterView.doorPhotosView.chooseImageView.isHidden = false
                self.addShoppFooterView.doorPhotosView.deletaBtn.isHidden = false
                self.addShoppFooterView.doorPhotosView.contentImageView.isHidden = true
                self.addShoppFooterView.doorPhotosView.titleContentView.isHidden = true
                self.addShoppFooterView.doorPhotosView.chooseImageView.image = editedImage
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePickerVc.dismiss(animated: true, completion: nil)
    }
}



