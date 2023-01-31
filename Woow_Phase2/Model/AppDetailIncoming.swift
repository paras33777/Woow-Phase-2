//
//  AppDetailIncoming.swift
//  WooW
//
//  Created by Rahul Chopra on 06/05/21.
//

import Foundation

class AppDetailIncoming {
    var serverData : [String: Any] = [:]
    var status_code : Int?
    var user_status : Int?
    var appDetail : [AppDetail]?
    init(dict: [String: Any]){
        self.serverData = dict
        
        if let status_code = dict["status_code"] as? Int {
            self.status_code = status_code
        }
        if let user_status = dict["user_status"] as? Int {
            self.user_status = user_status
        }
        if let vIDEO_STREAMING_APP = dict["VIDEO_STREAMING_APP"] as? [[String : Any]] {
            self.appDetail = []
            for object in vIDEO_STREAMING_APP {
                let some =  AppDetail(dict: object)
                self.appDetail?.append(some)
                
            }
        }
    }
    class AppDetail {
        var serverData : [String: Any] = [:]
        var interstital_ad : String?
        var banner_ad_type : String?
        var app_name : String?
        var app_contact : String?
        var app_company : String?
        var interstitial_ad_type : String?
        var app_privacy : String?
        var banner_ad_id : String?
        var interstital_ad_id : String?
        var app_package_name : String?
        var publisher_id : String?
        var interstital_ad_click : String?
        var app_version : String?
        var app_website : String?
        var banner_ad : String?
        var app_logo : String?
        var app_email : String?
        var success : String?
        var app_about : String?
        init(dict: [String: Any]){
            self.serverData = dict
            
            if let interstital_ad = dict["interstital_ad"] as? String {
                self.interstital_ad = interstital_ad
            }
            if let banner_ad_type = dict["banner_ad_type"] as? String {
                self.banner_ad_type = banner_ad_type
            }
            if let app_name = dict["app_name"] as? String {
                self.app_name = app_name
            }
            if let app_contact = dict["app_contact"] as? String {
                self.app_contact = app_contact
            }
            if let app_company = dict["app_company"] as? String {
                self.app_company = app_company
            }
            if let interstitial_ad_type = dict["interstitial_ad_type"] as? String {
                self.interstitial_ad_type = interstitial_ad_type
            }
            if let app_privacy = dict["app_privacy"] as? String {
                self.app_privacy = app_privacy
            }
            if let banner_ad_id = dict["banner_ad_id"] as? String {
                self.banner_ad_id = banner_ad_id
            }
            if let interstital_ad_id = dict["interstital_ad_id"] as? String {
                self.interstital_ad_id = interstital_ad_id
            }
            if let app_package_name = dict["app_package_name"] as? String {
                self.app_package_name = app_package_name
            }
            if let publisher_id = dict["publisher_id"] as? String {
                self.publisher_id = publisher_id
            }
            if let interstital_ad_click = dict["interstital_ad_click"] as? String {
                self.interstital_ad_click = interstital_ad_click
            }
            if let app_version = dict["app_version"] as? String {
                self.app_version = app_version
            }
            if let app_website = dict["app_website"] as? String {
                self.app_website = app_website
            }
            if let banner_ad = dict["banner_ad"] as? String {
                self.banner_ad = banner_ad
            }
            if let app_logo = dict["app_logo"] as? String {
                self.app_logo = app_logo
            }
            if let app_email = dict["app_email"] as? String {
                self.app_email = app_email
            }
            if let success = dict["success"] as? String {
                self.success = success
            }
            if let app_about = dict["app_about"] as? String {
                self.app_about = app_about
            }
        }
    }
}
