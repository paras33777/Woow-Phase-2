//
//  ProfileIncoming.swift
//  WooW
//
//  Created by MAC on 15/05/21.
//

import Foundation

class ProfileIncoming {
    var serverData : [String: Any] = [:]
    var user : [User]?
    var status_code : Int?
    init(dict: [String: Any]){
        self.serverData = dict
        
        if let vIDEO_STREAMING_APP = dict["VIDEO_STREAMING_APP"] as? [[String : Any]] {
            self.user = []
            for object in vIDEO_STREAMING_APP {
                let some =  User(dict: object)
                self.user?.append(some)
                
            }
        }
        if let status_code = dict["status_code"] as? Int {
            self.status_code = status_code
        }
    }
    class User {
        var serverData : [String: Any] = [:]
        var msg : String?
        var email : String?
        var phone : String?
        var name : String?
        var user_id : Int?
        var user_address : String?
        var success : String?
        var user_image : String?
        init(dict: [String: Any]){
            self.serverData = dict
            
            if let msg = dict["msg"] as? String {
                self.msg = msg
            }
            if let email = dict["email"] as? String {
                self.email = email
            }
            if let phone = dict["phone"] as? String {
                self.phone = phone
            }
            if let name = dict["name"] as? String {
                self.name = name
            }
            if let user_id = dict["user_id"] as? Int {
                self.user_id = user_id
            }
            if let user_address = dict["user_address"] as? String {
                self.user_address = user_address
            }
            if let success = dict["success"] as? String {
                self.success = success
            }
            if let user_image = dict["user_image"] as? String {
                self.user_image = user_image
            }
        }
    }
}
