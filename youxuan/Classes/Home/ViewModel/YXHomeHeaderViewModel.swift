//
//  YXHomeHeaderViewModel.swift
//  youxuan
//
//  Created by 肖锋 on 2019/11/8.
//  Copyright © 2019 肖锋. All rights reserved.
//

import UIKit

class YXHomeHeaderViewModel {
    
    //模型数组
    var bannerArray : [YXBannerModel] = []
    
    //保存图片地址的数组
    var bannerUrlArray : [String] = []
    
    
}

extension YXHomeHeaderViewModel {
    func YX_reloadData(finishCallback: @escaping () -> ()) {
        YX_NetWorkRequest(target: .YX_getBannerList(parameters: NSDictionary.YX_getBannerListDict())) { (result) in
            //转模型
            self.bannerArray = YXBannerModel.mj_objectArray(withKeyValuesArray: result["data"]["content"].rawValue) as! [YXBannerModel]
            //遍历取出url
            for i in 0..<self.bannerArray.count {
                self.bannerUrlArray.append("\(pictureUrl)/\(self.bannerArray[i].imgUrl)")
            }
            finishCallback()
        }
    }
}
