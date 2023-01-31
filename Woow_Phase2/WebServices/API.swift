//
//  API.swift
//  WooW
//
//  Created by Rahul Chopra on 29/04/21.
//

import Foundation
import UIKit

let baseUrl = "http://woowchannel.com:4191/app/mobile/v1/"
let imageBaseUrl = "https://woowchannel.com/upload/source/"
let userImageBaseUrl = "http://woowchannel.com:4191/"
//let baseUrl = "https://woowchannel.com/api/v1/"
//let baseUrl = "http://staging.woowchannel.com/api/v1/"
let privacyURL = "https://woowchannel.com/page/privacy-policy"
let termConditionURL = "https://woowchannel.com/page/terms-of-use"


extension Api {
    func baseURl() -> String {
        switch self {
        default :
            return baseUrl + self.rawValued()
        }
    }
}

enum Api{
    case login
    case yesNo
    case signup
    case sendOTP
    case verifyOTP
    case forgotPassword
    case myDetails
    case uploadingImage
    case updateProfile
    case changePassword
    
    case home
    case movieDetail(Int)
    case moviesByCategory
    case moviesByLanguages(String)
    case watchMovie(Int)
    case recommandedMovies(Int)
    
    case watchSeries(Int)
    case allSeries(Int, String)
    case seriesByCategory
    case seriesDetail(Int)
    case recommandedSeries(Int)
    
    case channels
    
    case search(String)
    
    case subscriptionList
    case faq
    case kidsMode
    case addToFavorite
    case favoriteList
    case allLanguages
    case saveSubscription
    case likeDisLikeMovie
    case likeDisLikeSeries
    func rawValued() -> String {
        switch self {
        case .likeDisLikeMovie:
            return "movies/movie-like-dislike"
        case .likeDisLikeSeries:
            return "series/series-like-dislike"
        case .yesNo:
            return "home/accep-logout"
        case .login:
            return  "auth/login"
        case .signup:
            return "auth/signup"
        case .sendOTP:
            return "auth/sendOTP"
        case .verifyOTP:
            return "auth/verifyOtp"
        case .forgotPassword:
            return "auth/forgotPassword"
        case .myDetails:
            return "auth/me"
        case .uploadingImage:
            return "auth/uploading"
        case .updateProfile:
            return "auth/profileUpdate"
        case .changePassword:
            return "auth/changePassword"
            
        case .home:
            return "home/"
        case .movieDetail(let id):
            return "movies/\(id)"
        case .moviesByCategory:
            return "movies/moviesByCategory/all"
        case .moviesByLanguages(let genres):
            return "movies/moviesByLanguages/all?genre=\(genres)"
        case .watchMovie(let movieId):
            return "movies/watchMovie/\(movieId)"
        case .recommandedMovies(let id):
            return "movies/recommandedMovies/\(id)"
            
        case .watchSeries(let seriesId):
            return "series/watchSeries/\(seriesId)"
        case .allSeries(let langId, let genres):
            return "series?lang=\(langId)&genre=\(genres)"
        case .seriesByCategory:
            return "series/seriesByCategory/all"
        case .seriesDetail(let id):
            return "series/\(id)"
        case .recommandedSeries(let id):
            return "series/recommandedSeries/\(id)"
            
        case .channels:
            return "channel/channelList"
        case .search(let searchText):
            return "home/search?search=\(searchText)"
            
        case .subscriptionList:
            return "subscription/subscriptionlist"
        case .faq:
            return "home/faq"
        case .kidsMode:
            return "home/kids-settings"
        case .addToFavorite:
            return "home/favorite"
        case .favoriteList:
            return "home/favorites"
            
        case .allLanguages:
            return "home/languageListing"
        case .saveSubscription:
            return "subscription/saveSubscription"
            
        }
    }
}


func isSuccess(json : [String : Any] , _ success : Int = 200) -> Bool{
    if let isSucess = json["success"] as? Int {
        if isSucess == success{
            return true
        }
    } else if let isSucess = json["success"] as? String {
        if isSucess == "\(success)"{
            return true
        }
    } else if let statusCode = json["status_code"] as? Int {
        if statusCode == success{
            return true
        }
    }
    return false
}

func isSuccess(statusCode: String , _ success : String = "200") -> Bool{
    if statusCode == success{
        return true
    } else if statusCode == "\(success)"{
        return true
    } else if statusCode == success{
        return true
    }
    return false
}


func message(json : [String : Any]) -> String{
    if let isSucess = json["success"] as? Int {
        if isSucess == 400{
            return json["message"] as! String
        }
    }
    if let message = json["error_msg"] as? String {
        return message
    }
    if let message = json["message"] as? String {
        return message
    }
    if let message = json["error_description"] as? String {
        return message
    }
    return ""
}



class API {
    static let shared = API()
    static private let apiKey = "viaviweb"
    var signCode = ""
    var salt = "0"
    
    func sign() -> String {
        salt = getRandomSalt()
        signCode = (API.apiKey + salt).md5
        signCode = signCode.replacingOccurrences(of: "+", with: "-")
                    .replacingOccurrences(of: "/", with: "_")
                    .replacingOccurrences(of: "=", with: "")
        print(signCode)
        return signCode
    }
    
    private func getRandomSalt() -> String {
        let randomNumber = Int.random(in: 1...900)
        salt = "\(randomNumber)"
        return "\(randomNumber)"
    }
}
