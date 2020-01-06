//
//  YXNetworkManager.swift
//  youxuan
//
//  Created by 肖锋 on 2019/10/17.
//  Copyright © 2019 肖锋. All rights reserved.
//

import UIKit
import Moya
import Alamofire
import SwiftyJSON

//超时时长
private var requestTimeOut : Float = 30

/******闭包定义******/
//成功数据回调
typealias successCallback = ((JSON) -> ())

//失败的回调
typealias failedCallback = ((JSON) -> ())

//网络错误的回调或者其它回调
typealias errorCallback = (() -> (Void))

/******************/

//网络请求的基本设置,这里可以拿到是具体的哪个网络请求，可以在这里做一些设置
private let myEndpointClosure = { (target : YXAPI) -> Endpoint in

    let url = target.baseURL.absoluteString + target.path//组装URL

    var task = target.task//调出task任务

    var endPoint = Endpoint(
        url: url,
        sampleResponseClosure:{ .networkResponse(200, target.sampleData) },
        method: target.method,
        task: task,
        httpHeaderFields: target.headers
    )
    
    //设置接口的超时时长
    requestTimeOut = 30//每次请求都会调用endpointClosure 到这里设置超时时长 也可单独每个接口设置
    switch target {//也可以在下面使用case单独设置超时时长
    default:
        return endPoint
    }
}

//网络请求的设置
private let requestClosure = { (endpoint : Endpoint, done : MoyaProvider.RequestResultClosure) in
    //捕获异常
    do {
        var request = try endpoint.urlRequest()
        
        //设置时长
        request.timeoutInterval = TimeInterval(requestTimeOut)
        
        //这里添加的token值
        print("传入的token值是:\(String(describing: YXUserDefulatTools.YX_getUserDefult()))")
        
        request.addValue(YXUserDefulatTools.YX_getUserDefult() ?? "", forHTTPHeaderField: "token")
        
        //打印参数
        if let requestData = request.httpBody {
            print("\(request.url!)"+"\n"+"\(request.httpMethod ?? "")"+"发送参数"+"\(String(data: request.httpBody!, encoding: String.Encoding.utf8) ?? "")")
        }else {
            print("\(request.url!)"+"\(String(describing: request.httpMethod))")
        }
        done(.success(request))
    } catch {
        done(.failure(MoyaError.underlying(error, nil)))
    }
}


//网络请求发送的核心初始化方法，创建网络请求对象
let provider = MoyaProvider<YXAPI>(endpointClosure: myEndpointClosure, requestClosure: requestClosure, trackInflights: false)

//最常用的网络请求，只需知道正确的结果无需其他操作
func YX_NetWorkRequest(target : YXAPI, completion : @escaping successCallback){
    YX_NetworkRequest(target : target, succsee : completion, failed : nil, error : nil)
}

//需要知道成功或者失败的网络请求， 要知道code码为其他情况
func NetWorkRequest(target : YXAPI, completion : @escaping successCallback , failed : failedCallback?) {
    YX_NetworkRequest(target : target, succsee : completion, failed : failed, error : nil)
}

//网络请求
func YX_NetworkRequest(target : YXAPI, succsee : @escaping successCallback, failed : failedCallback?, error : errorCallback?){
    
    provider.request(target) { (result) in
        
        switch result {
        case let .success(response)://成功
            
            print("---------response:\(response.data)")
            
            do {
                
                let jsonData = try JSON(data: response.data)
                
                //打印json
                print("成功:++++++\(target)++++++++++++\(jsonData)")
                
                if jsonData[YX_ResultCode].stringValue != "0" {
                    if jsonData[YX_ResultCode].stringValue == "90005" {
                        YXMBProgressHUDTools.YX_presentHudWithMessage(message: jsonData[YX_ResultMessage].stringValue)
                        //这里需要跳转到登录控制器
                        YXUserDefulatTools.YX_removeUserDefult()
                    }
                }
                succsee(jsonData)
            } catch  {
                
            }
        case let .failure(error):
            print(error)
            
        }
    }
}

