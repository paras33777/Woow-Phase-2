//
//  Cookies.swift
//  WooW
//
//  Created by Rahul Chopra on 06/05/21.
//

import Foundation
import UIKit

class Cookies {
    
    class func userInfoSave(user : User){
        do {
            let encodedUser = try JSONEncoder().encode(user)
            UserDefaults.standard.set(encodedUser, forKey: "userInfoSave")
            UserDefaults.standard.synchronize()
        } catch {
            print("Failed archived user data")
        }
    }
    
    class func userInfo() -> User? {
        if let some =  UserDefaults.standard.object(forKey: "userInfoSave") as? Data {
            do {
                let decodedUser = try JSONDecoder().decode(User.self, from: some)
                return decodedUser
            } catch {
                print("Failed unarchived user data")
            }
        }
        return nil
    }
    
    class func deleteUserInfo() {
        UserDefaults.standard.removeObject(forKey: "userInfoSave")
    }
    
}
