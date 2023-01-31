//
//  SubscPlanIncoming.swift
//  WooW
//
//  Created by MAC on 19/05/21.
//

import Foundation
import StoreKit

enum SubscriptionPlanEnum: String {
    case none = "None"
    case monthly = "1 Month"
    case halfYearly = "6 Months"
    case annually = "1 Year"
}

// MARK: - SubscriptionPlanModel
struct SubscriptionPlanModel: Codable {
    let success: Bool?
    let code: Int?
    let message: String?
    let body: [Subscription]?
    
    // MARK: - Body
    struct Subscription: Codable {
        let id: Int?
        let planName: String?
        let planDays: Int?
        let planDuration, planDurationType, planPrice, planIntPrice: String?
        let status: Int?
        var product: SKProduct?
        var planEnum: SubscriptionPlanEnum = .none
        var isSelected: Bool = false

        enum CodingKeys: String, CodingKey {
            case id
            case planName = "plan_name"
            case planDays = "plan_days"
            case planDuration = "plan_duration"
            case planDurationType = "plan_duration_type"
            case planPrice = "plan_price"
            case planIntPrice = "plan_int_price"
            case status
        }
    }
}
