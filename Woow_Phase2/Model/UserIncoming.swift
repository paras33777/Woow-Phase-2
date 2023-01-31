//
//  UserIncoming.swift
//  WooW
//
//  Created by Rahul Chopra on 06/05/21.
//

import Foundation

struct UserIncoming: Codable {
    var status_code : Int?
    var users : [User]?
    
    enum CodingKeys: String, CodingKey {
        case status_code = "status_code"
        case users = "VIDEO_STREAMING_APP"
    }
}


class User: Codable {
    var success : String?
    var name : String?
    var confirmation_code : String?
    var user_image : String?
    var msg : String?
    var user_id : Int?
    var email : String?
    var phone: String?
    var user_address: String?
    
    init(dict: [String:Any]) {
        if let phone = dict["phone"] as? String {
            self.phone = phone
        }
        if let user_address = dict["user_address"] as? String {
            self.user_address = user_address
        }
        if let success = dict["success"] as? String {
            self.success = success
        }
        if let name = dict["name"] as? String {
            self.name = name
        }
        if let confirmation_code = dict["confirmation_code"] as? String {
            self.confirmation_code = confirmation_code
        }
        if let user_image = dict["user_image"] as? String {
            self.user_image = user_image
        }
        if let msg = dict["msg"] as? String {
            self.msg = msg
        }
        if let user_id = dict["user_id"] as? Int {
            self.user_id = user_id
        }
        if let email = dict["email"] as? String {
            self.email = email
        }
    }
}


/*class UserIncoming {
    var serverData : [String: Any] = [:]
    var status_code : Int?
    var users : [User]?
    init(dict: [String: Any]){
        self.serverData = dict
        
        if let status_code = dict["status_code"] as? Int {
            self.status_code = status_code
        }
        if let vIDEO_STREAMING_APP = dict["VIDEO_STREAMING_APP"] as? [[String : Any]] {
            self.users = []
            for object in vIDEO_STREAMING_APP {
                let some =  User(dict: object)
                self.users?.append(some)
                
            }
        }
    }
    
    class User: Codable {
        var serverData : [String: Any] = [:]
        var success : String?
        var name : String?
        var confirmation_code : String?
        var user_image : String?
        var msg : String?
        var user_id : Int?
        var email : String?
        init(dict: [String: Any]){
            self.serverData = dict
            
            if let success = dict["success"] as? String {
                self.success = success
            }
            if let name = dict["name"] as? String {
                self.name = name
            }
            if let confirmation_code = dict["confirmation_code"] as? String {
                self.confirmation_code = confirmation_code
            }
            if let user_image = dict["user_image"] as? String {
                self.user_image = user_image
            }
            if let msg = dict["msg"] as? String {
                self.msg = msg
            }
            if let user_id = dict["user_id"] as? Int {
                self.user_id = user_id
            }
            if let email = dict["email"] as? String {
                self.email = email
            }
        }
        
        required convenience init(coder decoder: NSCoder) {
            self.success = decoder.decodeObject(forKey: "success") as? String
            self.name = decoder.decodeObject(forKey: "name") as? String
            self.confirmation_code = decoder.decodeObject(forKey: "confirmation_code") as? String
            self.user_image = decoder.decodeObject(forKey: "user_image") as? String
            self.msg = decoder.decodeObject(forKey: "msg") as? String
            self.user_id = decoder.decodeInteger(forKey: "user_id")
            self.email = decoder.decodeObject(forKey: "email") as? String
        }

        func encodeWithCoder(coder: NSCoder) {
            coder.encode(self.success, forKey: "success")
            coder.encode(self.name, forKey: "name")
            coder.encode(self.confirmation_code, forKey: "confirmation_code")
            coder.encode(self.user_image, forKey: "user_image")
            coder.encode(self.msg, forKey: "msg")
            coder.encode(self.user_id, forKey: "user_id")
            coder.encode(self.email, forKey: "email")
        }
    }
}
*/



// MARK: - OTPVerifyModel
struct OTPVerifyModel: Codable {
    let success: Bool?
    let code: Int?
    let message: String?
    let body: Body?
    
    // MARK: - Body
    struct Body: Codable {
        let otp: Int?
        let mobile: String?
    }
}
