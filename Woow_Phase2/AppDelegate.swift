//
//  AppDelegate.swift
//  Woow_Phase2
//
//  Created by Rahul Chopra on 08/12/21.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleSignIn
import Photos
import ScreenProtectorKit
import UserNotificationsUI

//import JioAdsFramework

let appDelegate = UIApplication.shared.delegate as! AppDelegate

@main
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {

    var deviceOrientation = UIInterfaceOrientationMask.portrait
    var window: UIWindow?
    private lazy var screenProtectorKit = { return ScreenProtectorKit(window: window) }()

    weak var screen : UIView? = nil

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        screenProtectorKit.configurePreventionScreenshot()
        IQKeyboardManager.shared.enable = true
//        GIDSignIn.sharedInstance.clientID = APIKeys.kGoogleSignInKey
//        JioAdSdk.setLogLevel(logLevel: .DEBUG)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didScreenRecording(_:)),
            name: UIScreen.capturedDidChangeNotification,
            object: nil
        )
        if #available(iOS 10.0, *) {
                         // For iOS 10 display notification (sent via APNS)
                         UNUserNotificationCenter.current().delegate = self
                         
                         let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
                         UNUserNotificationCenter.current().requestAuthorization(
                             options: authOptions,
                             completionHandler: {_, _ in })
                     } else {
                         let settings: UIUserNotificationSettings =
                             UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
                         application.registerUserNotificationSettings(settings)
                     }
                     
                     application.registerForRemoteNotifications()



        //Define a listener to handle the case when a screenshot is performed
        //Unfortunately screenshot cannot be prevented but just detected...
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(didScreenshot(_:)),
//            name: UIApplication.userDidTakeScreenshotNotification,
//            object: nil)
        return true
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {

               print("i am not available in simulator \(error)")
       }
    
    //Get device token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    {
        let tokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        
        print("The token: \(tokenString)")
//     Cookies.saveDeviceToken(token: tokenString)
        UserDefaults.standard.setValue(tokenString, forKey: "DeviceToken")

    }
    @objc private func didScreenshot(_ notification: Notification) {
//        #if DEBUG
//        blurScreen()
        if UIScreen.main.isCaptured {
            Alert.showSimple("Screenshots are not allowed in our app due to security purpose!")
            blurScreen()

        }else{
            removeBlurScreen()

        }

        //Never add this log in RELEASED app.
        print("Screen capture detected then we force the immediate exit of the app!")
//        #endif
//        PHPhotoLibrary.shared().performChanges({
//                        let imageAssetToDelete = PHAsset.fetchAssets(withALAssetURLs: imageUrls as! [URL], options: nil)
//                        PHAssetChangeRequest.deleteAssets(imageAssetToDelete)
//                    }, completionHandler: {success, error in
//                        print(success ? "Success" : error )
//                    })
//        removeBlurScreen()

        //Information about the image is not available here and screenshot cannot be prevented AS IS
        //See hint here about a way to address this issue:
        //https://tumblr.jeremyjohnstone.com/post/38503925370/how-to-detect-screenshots-on-ios-like-snapchat
        //In all case: Send notification to the backend and clear all local data/secret from the storage/keychain
//        exit(0)
    }
    
    @objc private func didScreenRecording(_ notification: Notification) {
        //If a screen recording operation is pending then we close the application
        print(UIScreen.main.isCaptured)
        if UIScreen.main.isCaptured {
            Alert.showSimple("Screen recording is not allowed in our app due to security purpose!")
            blurScreen()

//            #if DEBUG
            //Never add this log in RELEASED app.
            print("Screen recording detected then we force the immediate exit of the app!")
//            #endif
//            exit(0)
        } else {
            removeBlurScreen()
        }
    }

    func blurScreen(style: UIBlurEffect.Style = UIBlurEffect.Style.regular) {
        screen = UIScreen.main.snapshotView(afterScreenUpdates: false)
        let blurEffect = UIBlurEffect(style: style)
        let blurBackground = UIVisualEffectView(effect: blurEffect)
        screen?.addSubview(blurBackground)
        blurBackground.frame = (screen?.frame)!
        window?.addSubview(screen!)
    }

    func removeBlurScreen() {
        screen?.removeFromSuperview()
    }
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
//        if let navigationController = self.window?.rootViewController as? UINavigationController {
//            if navigationController.visibleViewController is PortraitPlayerVC {
//                return UIInterfaceOrientationMask.all
//            } else if navigationController.visibleViewController is MovieDetailVC {
//                return UIInterfaceOrientationMask.all
//            }  else if navigationController.visibleViewController is SeriesDetailVC {
//                return UIInterfaceOrientationMask.all
//            } else {
//                return UIInterfaceOrientationMask.portrait
//            }
//        }
        return UIInterfaceOrientationMask.portrait
    }
    
    func applicationDidBecomeActive(_ application: UIApplication){
//        screenProtectorKit.disableColorScreen()
        screenProtectorKit.enabledPreventScreenshot()
        if #available(iOS 14, *) {
//            JioAdSdk.requestAppTrackingPermission { (status) in
//                if status != .authorized, let vendorStr = UIDevice.current.identifierForVendor?.uuidString {
//                    JioAdSdk.setDeviceVendorId(vendorStr)
//                }
//                //..Publishere can use below line of code if authorization is denied
//                if status == .denied {
//                    DispatchQueue.main.async {
//                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
//                    }
//                }
//            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        screenProtectorKit.disablePreventScreenshot()
        }
}

