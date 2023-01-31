//
//  UpdateUserModel.swift
//  Woow_Phase2
//
//  Created by Rahul Chopra on 12/05/22.
//

import Foundation

// MARK: - UpdateUserModel
struct UpdateUserModel: Codable {
    var success: Bool?
    var code: Int?
    var message: String?
    var body: UserModel.UserDetails?
    
//    // MARK: - Body
//    struct Body: Codable {
//        var id: Int?
//        var usertype: String?
//        var loginStatus: Int?
//        var googleID, facebookID: JSONNull?
//        var name, email, password, countryCode: String?
//        var phone: String?
//        var phoneVerification: Int?
//        var userAddress, userImage: JSONNull?
//        var status, planID: Int?
//        var startDate, expDate, paypalPaymentID, stripePaymentID: JSONNull?
//        var razorpayPaymentID, paystackPaymentID: JSONNull?
//        var planAmount, confirmationCode: String?
//        var rememberToken, sessionID: JSONNull?
//        var familyContent, notificationSetting: Int?
//        var createdAt: JSONNull?
//        var updatedAt: String?
//
//        enum CodingKeys: String, CodingKey {
//            case id, usertype
//            case loginStatus = "login_status"
//            case googleID = "google_id"
//            case facebookID = "facebook_id"
//            case name, email, password
//            case countryCode = "country_code"
//            case phone
//            case phoneVerification = "phone_verification"
//            case userAddress = "user_address"
//            case userImage = "user_image"
//            case status
//            case planID = "plan_id"
//            case startDate = "start_date"
//            case expDate = "exp_date"
//            case paypalPaymentID = "paypal_payment_id"
//            case stripePaymentID = "stripe_payment_id"
//            case razorpayPaymentID = "razorpay_payment_id"
//            case paystackPaymentID = "paystack_payment_id"
//            case planAmount = "plan_amount"
//            case confirmationCode = "confirmation_code"
//            case rememberToken = "remember_token"
//            case sessionID = "session_id"
//            case familyContent = "family_content"
//            case notificationSetting = "notification_setting"
//            case createdAt = "created_at"
//            case updatedAt = "updated_at"
//        }
//    }

}
