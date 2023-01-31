//
//  UserModel.swift
//  Woow_Phase2
//
//  Created by Rahul Chopra on 16/02/22.
//

import Foundation

// MARK: - UserModel
struct UserModel: Codable {
    let success: Bool?
    let code: Int?
    let message: String?
    let body: Body?
    
    // MARK: - Body
    struct Body: Codable {
        let token: String?
        let already_login:Int?
        let userDetails: UserDetails?
    }

    // MARK: - UserDetails
    struct UserDetails: Codable {
        let id: Int?
        let usertype: String?
        let loginStatus: Int?
        let googleID, facebookID: String?
        let name, email, password, countryCode: String?
        let phone, gender: String?
        let phoneVerification: Int?
        let userAddress, userImage: String?
        let status, planID: Int?
        let paypalPaymentID, stripePaymentID: String?
        let razorpayPaymentID, paystackPaymentID: String?
        let planAmount: String?
        let rememberToken, sessionID: String?
        let familyContent, startDate, expDate: Int?
        let createdAt, updatedAt: String?
//        let confirmationCode: Int?

        enum CodingKeys: String, CodingKey {
            case id, usertype
            case loginStatus = "login_status"
            case googleID = "google_id"
            case facebookID = "facebook_id"
            case name, email, password
            case countryCode = "country_code"
            case phone
            case phoneVerification = "phone_verification"
            case userAddress = "user_address"
            case userImage = "user_image"
            case status, gender
            case planID = "plan_id"
            case startDate = "start_date"
            case expDate = "exp_date"
            case paypalPaymentID = "paypal_payment_id"
            case stripePaymentID = "stripe_payment_id"
            case razorpayPaymentID = "razorpay_payment_id"
            case paystackPaymentID = "paystack_payment_id"
            case planAmount = "plan_amount"
//            case confirmationCode = "confirmation_code"
            case rememberToken = "remember_token"
            case sessionID = "session_id"
            case familyContent = "family_content"
            case createdAt = "created_at"
            case updatedAt = "updated_at"
        }
    }
}
