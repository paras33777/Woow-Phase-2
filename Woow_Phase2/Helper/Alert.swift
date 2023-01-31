//
//  Alert.swift
//  WooW
//
//  Created by Rahul Chopra on 29/04/21.
//

import Foundation
import UIKit

let appName = "Alert" //Bundle.main.infoDictionary!["CFBundleName"] as! String

extension UIViewController {
    
    func showAlertWithAction(Title: String , Message: String , ButtonTitle: String ,outputBlock:@escaping ()->Void) {
        
        let alert = UIAlertController(title: Title, message: Message, preferredStyle: UIAlertController.Style.alert)
        
        alert.view.tintColor = UIColor.black
        
        alert.addAction(UIAlertAction(title: ButtonTitle, style: .default, handler: { (action: UIAlertAction!) in
            
            outputBlock()
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func showAlertWithActionOkandCancel(Title: String , Message: String , OkButtonTitle: String ,CancelButtonTitle: String ,outputBlock:@escaping ()->Void) {
        
        let alert = UIAlertController(title: Title, message: Message, preferredStyle: UIAlertController.Style.alert)
        alert.view.tintColor = UIColor.black
        alert.addAction(UIAlertAction(title: CancelButtonTitle, style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: OkButtonTitle, style: .default, handler: { (action: UIAlertAction!) in
            
            outputBlock()
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    func showAlert(Title: String , Message: String , ButtonTitle: String) {
        
        let alert = UIAlertController(title: Title, message: Message, preferredStyle: UIAlertController.Style.alert)
        alert.view.tintColor = UIColor.black
        alert.addAction(UIAlertAction(title: ButtonTitle, style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func showDefaultAlert(Message: String) {
        
        let alert = UIAlertController(title: "RentaSari", message: Message, preferredStyle: UIAlertController.Style.alert)
        alert.view.tintColor = UIColor.black
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}



let appNameAlert = "Alert" //Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String


class Alert: UIAlertController {
    class func showSimple(_ message: String, completionHandler: (() -> Swift.Void)? = nil) {
        let keywindow = UIApplication.shared.keyWindow
        // let mainController = keywindow?.rootViewController
        let alert = UIAlertController(title: appNameAlert, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (_: UIAlertAction!) in
            print("Heloo ")
            completionHandler?()
        }))
        UIApplication.topViewController()?.present(alert, animated: true, completion: {
        })
        
    }
    
    // make sure you have navigation  view controller
    
    class func showComplex(title: String? = "",
                           message: String,
                           preferredStyle: UIAlertController.Style? = .alert,
                           cancelTilte: String,
                           otherButtons: String ...,
        comletionHandler: ((Swift.Int) -> Swift.Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle!)
        
        for i in otherButtons {
            //  print( UIApplication.topViewController() ?? i  )
            
            alert.addAction(UIAlertAction(title: i, style: UIAlertAction.Style.default,
                                          handler: { (action: UIAlertAction!) in
                                            
                                            comletionHandler?(alert.actions.index(of: action)!)
                                            
            }
            ))
            
        }
        if (cancelTilte as String?) != nil {
            alert.addAction(UIAlertAction(title: cancelTilte, style: UIAlertAction.Style.destructive,
                                          handler: { (action: UIAlertAction!) in
                                            
                                            comletionHandler?(alert.actions.index(of: action)!)
                                            
            }
            ))
        }
        
        UIApplication.topViewController()?.present(alert, animated: true, completion: {
            
        })
        
    }
    
    class func show(title: String? = nil, message: String, actionTitle1: String? = nil, actionTitle2: String? = nil, actionTitle3: String? = nil, destructiveIndex: Int? = nil, cancelIndex: Int? = nil, alertStyle: UIAlertController.Style = .alert, completionOK: (() -> ())? = nil, completionCancel: (() -> ())? = nil) {
        let alert = UIAlertController(title: title == nil ? appName : title!, message: message, preferredStyle: alertStyle)
        let actionOk = UIAlertAction(title: actionTitle1 ?? "Ok", style: .default) { (_) in
            if completionOK != nil {
                completionOK!()
            }
        }
        alert.addAction(actionOk)
        
        if actionTitle2 != nil {
            var style = UIAlertAction.Style.default
            if destructiveIndex != nil {
                if destructiveIndex! == 1 {
                    style = .destructive
                }
            } else {
                if cancelIndex != nil {
                    if cancelIndex! == 1 {
                        style = .cancel
                    }
                }
            }
            
            let actionCancel = UIAlertAction(title: actionTitle2 ?? "Cancel", style: style) { (_) in
                if completionCancel != nil {
                    completionCancel!()
                }
            }
            alert.addAction(actionCancel)
        }
        
        if actionTitle3 != nil {
            var style = UIAlertAction.Style.default
            if destructiveIndex != nil {
                if destructiveIndex! == 2 {
                    style = .destructive
                }
            } else {
                if cancelIndex != nil {
                    if cancelIndex! == 2 {
                        style = .cancel
                    }
                }
            }
            
            let actionCancel = UIAlertAction(title: actionTitle3 ?? "Cancel", style: style) { (_) in
                
            }
            alert.addAction(actionCancel)
        }
        
        UIApplication.rootViewController().present(alert, animated: true, completion: nil)
    }
    
    
    class func showAlertWithBtn(title: String? = "",
                                message: String,
                                preferredStyle: UIAlertController.Style? = .alert,
                                buttons: [UIAlertAction]) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle!)
        for button in buttons {
            alert.addAction(button)
        }
        UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
    }
    
}

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
    
    class func window() -> UIWindow {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.windows.first!
        } else {
            return UIApplication.shared.keyWindow!
        }
    }
    
    class func rootViewController() -> UIViewController {
        return window().rootViewController!
    }
}
