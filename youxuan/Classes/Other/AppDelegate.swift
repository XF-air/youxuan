//
//  AppDelegate.swift
//  youxuan
//
//  Created by 肖锋 on 2019/10/12.
//  Copyright © 2019年 肖锋. All rights reserved.
//

import UIKit
import CYLTabBarController
import AMapLocationKit
import AMapFoundationKit

private let YXWECHATELink : String = "https://help.wechat.com/app/"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var backgroundTask : UIBackgroundTaskIdentifier! = nil
    
    var adcode : String = ""
    var city : String = ""
    
    private lazy var locationManager : AMapLocationManager = {
        let locationManager = AMapLocationManager()
        return locationManager
    }()
    
    //单例
    static let sharedInstance = AppDelegate()
    private override init(){}
    

    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //注册地图
        AMapServices.shared()?.apiKey = "9f7cf864e6f608bc154142f32a9a6a90"
        //注册微信
        WXApi.registerApp("wxae0b22f6ae0c88e7", universalLink: YXWECHATELink)
        
        YX_getLocation()
        
        YX_setUpRootTabBar()
        
        YX_setNavigationgState()
        
        
        return true
    }
    
    //强制使用系统的自带键盘
    func application(_ application: UIApplication, shouldAllowExtensionPointIdentifier extensionPointIdentifier: UIApplication.ExtensionPointIdentifier) -> Bool {
        if extensionPointIdentifier.rawValue == "com.apple.keyboard-service" {
            return false
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // 延迟程序静止的时间
        DispatchQueue.global().async() {
            //如果已存在后台任务，先将其设为完成
            if self.backgroundTask != nil {
                application.endBackgroundTask(self.backgroundTask)
                self.backgroundTask = UIBackgroundTaskIdentifier.invalid
            }
        }
           
        //如果要后台运行
        self.backgroundTask = application.beginBackgroundTask(expirationHandler: {
               () -> Void in
            //如果没有调用endBackgroundTask，时间耗尽时应用程序将被终止
            application.endBackgroundTask(self.backgroundTask)
            self.backgroundTask = UIBackgroundTaskIdentifier.invalid
        })
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

extension AppDelegate {
    //设置主控制器
    func YX_setUpRootTabBar(){
        self.window = UIWindow()
        self.window?.frame  = UIScreen.main.bounds
        self.window?.backgroundColor = UIColor.white
        self.window?.rootViewController = YX_setUpTabBarMessage()
        self.window?.makeKeyAndVisible()
    }
    
    //设置tabBar中的相关内容
    private func YX_setUpTabBarMessage() -> MainTabBarController{
        let mainTabBarVc = MainTabBarController(viewControllers: YX_setUpNavgitionViewControllers(), tabBarItemsAttributes: YX_setUpTabBarItemsAttributesForController(), imageInsets: .zero, titlePositionAdjustment: UIOffset(horizontal: 0, vertical: -2.5))

        //设置阴影
        mainTabBarVc.tabBar.layer.shadowColor = UIColor.lightGray.cgColor;
        mainTabBarVc.tabBar.layer.shadowOffset = CGSize(width: 0, height: -3);
        mainTabBarVc.tabBar.layer.shadowOpacity = 0.1;
        mainTabBarVc.tabBar.barTintColor = UIColor.white
        
        //设置item相关属性
        let tabBarItem = UITabBarItem.appearance()
        
        //普通状态
        tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.YX_getColor(rgbValue: 0x000000)], for: .normal)
        //选中状态
        tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.YX_getColor(rgbValue: 0xFF333C)], for: .selected)

        // 半透明
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().backgroundColor = UIColor.white
        mainTabBarVc.hideTabBadgeBackgroundSeparator();

        return mainTabBarVc
    }
    
    //创建以导航条控制器为基础的数组
    private func YX_setUpNavgitionViewControllers() -> [UIViewController] {
        let home = YXNavigationController(rootViewController: YXHomeViewController())
        let classification = YXNavigationController(rootViewController: YXClassificationViewController())
        let shoppCart = YXNavigationController(rootViewController: YXShoppingCartViewController())
        let mine = YXNavigationController(rootViewController: YXMineViewController())
        let viewControllers = [home, classification, shoppCart, mine]
        return viewControllers
    }
    
    //设置tabBar的图片和相关内容
    private func YX_setUpTabBarItemsAttributesForController() -> [[String : String]] {
        let homeTabBarItem = [CYLTabBarItemTitle:"首页",
                              CYLTabBarItemImage:"icon_home_nor",
                              CYLTabBarItemSelectedImage:"icon_home_sel"]
        
        let classificationTabBarItem = [CYLTabBarItemTitle:"分类",
                                        CYLTabBarItemImage:"icon_type_nor",
                                        CYLTabBarItemSelectedImage:"icon_type_sel"]
        
        let shoppCartTabBarItem = [CYLTabBarItemTitle:"购物车",
                                   CYLTabBarItemImage:"icon_shopping_nor",
                                   CYLTabBarItemSelectedImage:"icon_shopping_sel"]

        let mineTabBarItem = [CYLTabBarItemTitle:"我的",
                              CYLTabBarItemImage:"icon_mine_nor",
                              CYLTabBarItemSelectedImage:"icon_mine_sel"]
        let tabBarItemsAttributes = [homeTabBarItem, classificationTabBarItem, shoppCartTabBarItem, mineTabBarItem]
        return tabBarItemsAttributes
    }
    
    //设置导航栏的色调
    private func YX_setNavigationgState(){
        UINavigationBar.appearance().isTranslucent = false//调整不透明度,防止导航栏设置成白色,但是不显示完全白色出现bug
    }
}

//获取地理位置
extension AppDelegate {
    private func YX_getLocation(){
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.requestLocation(withReGeocode: true) { (location, regeocode, error) in
            print("adcode：\(String(describing: regeocode?.adcode)) ----------city: \(String(describing: regeocode?.city))")
            if regeocode?.city != nil {
                AppDelegate.sharedInstance.adcode = regeocode!.adcode
                AppDelegate.sharedInstance.city = regeocode!.city
            }
            //这里发送通知
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                NotificationCenter.default.post(name: NSNotification.Name(YXRECEIVEDLOCATIONNOTIFICATION), object: nil)
            }
        }
    }
}

//支付回调
extension AppDelegate {
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.host == "safepay" {//阿里支付回调
            AlipaySDK.defaultService()?.processOrder(withPaymentResult: url, standbyCallback: { (resultDict) in
                var payResoult : String = ""
                switch resultDict!["resultStatus"] as! String {
                case "9000":
                    payResoult = "订单支付成功"
                    self.YX_paySuccess()
                case "6001":
                    payResoult = "订单支付取消"
                default:
                    payResoult = "订单支付失败"
                }
                YXMBProgressHUDTools.YX_presentHudWithMessage(message: payResoult)
            })
        }else {//微信支付回调
            WXApi.handleOpen(url, delegate: self)
        }
        return true
    }
}

//微信支付回调的代理方法
extension AppDelegate : WXApiDelegate{
    func onResp(_ resp: BaseResp) {
        var payResoult : String = ""
        if resp.isKind(of: PayResp.self) {
            switch resp.errCode {
            case 0:
                payResoult = "订单支付成功"
                self.YX_paySuccess()
            case -2:
                payResoult = "订单支付取消"
            default:
                payResoult = "订单支付失败"
            }
            YXMBProgressHUDTools.YX_presentHudWithMessage(message: payResoult)
        }else {
            
        }
    }
}
//支付成功
extension AppDelegate {
    private func YX_paySuccess(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            //发送通知
            
        }
    }
}




