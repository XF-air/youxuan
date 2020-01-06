//
//  YXAPI.swift
//  youxuan
//
//  Created by 肖锋 on 2019/10/17.
//  Copyright © 2019 肖锋. All rights reserved.
//

import UIKit
import Moya


enum YXAPI {
    //上传图片
    case YX_uploadPictures(dataArry: NSMutableArray)
    //获取短信
    case YX_getCode(parameters: [String: Any])
    //登录
    case YX_login(parameters: [String : Any])
    //查询商铺信息
    case YX_checkShopp
    //获取nb
    case YX_getNb(parameters: [String : Any])
    //查询邀请码是不是必传
    case YX_getInvitationCode(parameters: [String : Any])
    //退出登录
    case YX_loginOut
    //添加商铺
    case YX_addShoppMessage(parameters: [String : Any])
    //修改商铺
    case YX_updateBusiness(parameters: [String : Any])
    //获取标题
    case YX_getGoodsList
    //获取分销商品信息
    case YX_getRetailGoods(parameters: [String : Any])
    //获取秒杀内容
    case YX_spikeActivity(parameters: [String : Any])
    //获取banner信息
    case YX_getBannerList(parameters: [String : Any])
    //获取所有的商品
    case YX_getAllGoodsList(parameters: [String : Any])
    //获取商品的详情
    case YX_getRetailGoodsDetail(parameters: [String : Any])
    //html
    case YX_getHtml(parameters: [String : Any])
    //查询商品规格
    case YX_getCheckGoodsInfo(parameters: [String : Any])
    //获取下单页面的信息
    case YX_getPlaceOrdersCost(parameters: [String : Any])
    //提交订单
    case YX_creatOrder(parameters: [String : Any])
    //支付
    case YX_sendPay(parameters: [String : Any])
    //取消订单
    case YX_cancelOrder(parameters: [String : Any])
    
}

extension YXAPI : TargetType {
    //设置URL
    var baseURL: URL {
        return URL.init(string: YX_BaseURLStr)!
    }
    
    var path: String {
        switch self {
        case .YX_uploadPictures:
            return "/image/img_uploads"
        case .YX_getCode:
            return "/sms/validation-code"
        case .YX_login:
            return "/login"
        case .YX_checkShopp:
            return "/user/business/one"
        case .YX_getNb:
            return "/account-ledger/user-ledger"
        case .YX_loginOut:
            return "/logout"
        case.YX_getInvitationCode:
            return "/platFormConfig/getByCode"
        case .YX_addShoppMessage:
            return "/user/business/creation"
        case .YX_updateBusiness:
            return "/user/business/update"
        case .YX_getGoodsList:
            return "/goods/list"
        case .YX_getRetailGoods:
            return "/retail-goods/goods-list"
        case .YX_spikeActivity:
            return "/activity-goods/all-goods"
        case .YX_getBannerList:
            return "/t-banner/list"
        case .YX_getAllGoodsList:
            return "/goods/all-goods"
        case .YX_getRetailGoodsDetail:
            return "/retail-goods/retail-goodsDetail"
        case .YX_getHtml:
            return "/retail-goods/details-h5"
        case .YX_getCheckGoodsInfo:
            return "/goods/goods-info"
        case .YX_getPlaceOrdersCost:
            return "/order/cost"
        case .YX_creatOrder:
            return "/order/create"
        case .YX_sendPay:
            return "/payment/send-pay"
        case .YX_cancelOrder:
            return "/order/cancel"
        }
    }

    var method: Moya.Method {
        switch self {
        case .YX_checkShopp, .YX_getCode, .YX_getNb, .YX_getInvitationCode, .YX_getGoodsList, .YX_getRetailGoods, .YX_spikeActivity, .YX_getBannerList, .YX_getAllGoodsList, .YX_getRetailGoodsDetail, .YX_getHtml, .YX_getCheckGoodsInfo, .YX_getPlaceOrdersCost, .YX_cancelOrder:
            return .get
        default:
            return .post
        }
    }

    var sampleData: Data {
        return Data(base64Encoded: "just for test")!
    }
    
    //将API的参数传进来,请求任务
    var task: Task {
        switch self {
        case .YX_getCode(let parameters), .YX_login(let parameters), .YX_getNb(let parameters), .YX_getInvitationCode(let parameters), .YX_addShoppMessage(let parameters), .YX_updateBusiness(let parameters), .YX_getRetailGoods(let parameters), .YX_spikeActivity(let parameters), .YX_getBannerList(let parameters), .YX_getAllGoodsList(let parameters), .YX_getRetailGoodsDetail(let parameters), .YX_getHtml(let parameters), .YX_getCheckGoodsInfo(let parameters), .YX_getPlaceOrdersCost(let parameters), .YX_creatOrder(let parameters), .YX_sendPay(let parameters), .YX_cancelOrder(let parameters):
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .YX_uploadPictures(let dataArry):
            let formDataAry: NSMutableArray = NSMutableArray()
            for (index, image) in dataArry.enumerated() {
                //图片转成Data
                let data: Data = (image as! UIImage).jpegData(compressionQuality: 0.9)!
                //根据当前时间设置图片上传时候的名字
                let date: Date = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd-HH:mm:ss"
                var dateStr: String = formatter.string(from: date as Date)
                //别忘记这里给名字加上图片的后缀
                dateStr = dateStr.appendingFormat("-%i.jpg", index)
                
                let formData = MultipartFormData(provider: .data(data), name: "files", fileName: dateStr, mimeType: "image/jpg")
                formDataAry.add(formData)
            }
//            return .uploadCompositeMultipart(formDataAry as! [MultipartFormData], urlParameters: nil)//如果是需要添加参数,直接使用的是这个方法
            return .uploadMultipart(formDataAry as! [MultipartFormData])
        case .YX_checkShopp, .YX_loginOut, .YX_getGoodsList:
            return .requestPlain
//        case .YX_sendPay(let parameters):
//            return .requestData(YXBaseTools.YX_jsonToData(jsonDic: parameters)!)
//            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
//            return .requestCompositeParameters(bodyParameters: parameters, bodyEncoding: JSONEncoding.default, urlParameters: [:])
//            return .requestCompositeData(bodyData: YXBaseTools.YX_jsonToData(jsonDic: parameters)!, urlParameters: [:])
        }
    }

    var headers: [String : String]? {
        return ["Content-Type":"application/x-www-form-urlencoded"]
    }
}
