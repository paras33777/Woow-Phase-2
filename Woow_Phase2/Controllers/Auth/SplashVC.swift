//
//  SplashVC.swift
//  WooW
//
//  Created by Rahul Chopra on 06/05/21.
//

import UIKit
//import GoogleMobileAds

class SplashVC: UIViewController {

    
    
    // MARK:- VIEW LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.getAppDetails()
        
        if UserData.User != nil {
            self.openContainerVC()
        } else {
//            self.openSignInVC()
            self.openContainerVC()
        }
    }
    

    // MARK:- API IMPLEMENTATIONS
    fileprivate func openContainerVC() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NTabBarVC") as! NTabBarVC
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "VLCPlayerVC") as! VLCPlayerVC
        let navVC = UINavigationController(rootViewController: vc)
        navVC.isNavigationBarHidden = true
        UIApplication.window().rootViewController = navVC
        UIApplication.window().makeKeyAndVisible()
    }
    
    func getAppDetails() {
        let sign = API.shared.sign()
        
        let userId = Cookies.userInfo()?.user_id ?? 0
        let param = ["user_id": "\(userId == 0 ? 0 : userId)",
                     "salt": API.shared.salt,
                     "sign": sign
                    ] as [String : Any]

//        Hud.show(message: "", view: self.view)
//        WebServices.uploadData(url: .app_details, jsonObject: param) { (jsonDict) in
////            Hud.hide(view: self.view)
//            print(jsonDict)
//
//            if isSuccess(json: jsonDict) {
//                let appDet = AppDetailIncoming(dict: jsonDict)
//                if let appDet = appDet.appDetail, let first = appDet.first {
//                    appDetail = first
//
//                    if UserData.User != nil {
//                        self.openContainerVC()
//                    } else {
//                        self.openSignInVC()
//                    }
//                }
//            } else {
//                self.openSignInVC()
//            }
//
//        } failureHandler: { (errorDict) in
//            Hud.hide(view: self.view)
//            print(errorDict)
//            self.openSignInVC()
//        }
    }
    
    func openSignInVC() {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NLoginVC") as! NLoginVC
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OnboardingVC") as! OnboardingVC
        let navVC = UINavigationController(rootViewController: vc)
        navVC.isNavigationBarHidden = true
        UIApplication.window().rootViewController = navVC
        UIApplication.window().makeKeyAndVisible()
    }
}
