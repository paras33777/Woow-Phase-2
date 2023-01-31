//
//  Constant.swift
//  WooW
//
//  Created by Rahul Chopra on 29/04/21.
//

import Foundation
import UIKit


var storyboardIdParam = "StoryboardIDS"
var appDetail: AppDetailIncoming.AppDetail?

let appstoreLink = "https://apps.apple.com/in/app/facebook/id284882215"

// MARK:- NOTIFICATION OBSERVER KEYS
struct NotificationKeys {
    static let kToggleMenu = NSNotification.Name(rawValue: "ToggleSideMenu")
    static let kLoadViewController = NSNotification.Name(rawValue: "LoadViewController")
}


struct APIKeys {
    static let kGoogleSignInKey = ""
}



//struct AppFonts {
//    static let SFProTextBold = UIFont(name: "SFProText-Bold", size: 15.0)!
//    static let SFProTextRegular = UIFont(name: "SFProText-Regular", size: 15.0)!
//    static let SFProDisplayBold = UIFont(name: "SFProDisplay-Bold", size: 15.0)!
//    static let SFProDisplayRegular = UIFont(name: "SFProDisplay-Regular", size: 15.0)!
//    static let SFProDisplayMedium = UIFont(name: "SFProDisplay-Medium", size: 15.0)!
//}
