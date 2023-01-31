//
//  UserData.swift
//  Woow_Phase2
//
//  Created by Rahul Chopra on 16/02/22.
//

import Foundation
import UIKit

final class UserData {
    private enum DataKey: String {
        case User
        case Token
    }
    
    static var User: UserModel.UserDetails? {
        get{
            if let decodedData = UserDefaults.standard.value(forKey: DataKey.User.rawValue) as? Data {
                do {
                    let info = try JSONDecoder().decode(UserModel.UserDetails.self, from: decodedData)
                    return info
                } catch {
                   print("Failed unarchiving user data")
                   return nil
                }
            } else {
                return nil
            }
        }
        set{
            do {
                let defaults = UserDefaults.standard
                let key = DataKey.User.rawValue
                if newValue == nil {
                    UserDefaults.standard.set(nil, forKey: key)
                } else {
                    let encodedData = try JSONEncoder().encode(newValue)
                    UserDefaults.standard.set(encodedData, forKey: key)
                }
                
                defaults.synchronize()
            } catch {
                print("Failed archiving user data")
            }
        }
    }
    
    static var Token: String? {
        get{
            if let decodedData = UserDefaults.standard.value(forKey: DataKey.Token.rawValue) as? String {
                return decodedData
            } else {
                return ""
            }
        }
        set{
            let defaults = UserDefaults.standard
            let key = DataKey.Token.rawValue
            if newValue == nil {
                UserDefaults.standard.set(nil, forKey: key)
            } else {
                UserDefaults.standard.set(newValue!, forKey: key)
            }
            
            defaults.synchronize()
        }
    }    
}
