//
//  MBProgressHud.swift
//  WooW
//
//  Created by Rahul Chopra on 29/04/21.
//

import Foundation
import UIKit
import MBProgressHUD

class Hud: NSObject {
    static let shareInstance = Hud()
    class func show(message:String, view:UIView) {
        let hud  = MBProgressHUD.showAdded(to: view, animated: true)
        hud.label.text = message
    }
    class func hide(view:UIView) {
        MBProgressHUD.hide(for: view, animated: true)
    }
}
