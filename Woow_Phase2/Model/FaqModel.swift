//
//  FaqModel.swift
//  Woow_Phase2
//
//  Created by Rahul Chopra on 30/04/22.
//

import Foundation

// MARK: - FAQModel
struct FAQModel: Codable {
    var success: Bool?
    var code: Int?
    var message: String?
    var body: [Body]?
    
    // MARK: - Body
    struct Body: Codable {
        var id: Int?
        var question, answer: String?
        var status: Bool?
        var createdAt, updatedAt: String?
        var isExpanded: Bool = false

        enum CodingKeys: String, CodingKey {
            case id, question, answer, status
            case createdAt = "created_at"
            case updatedAt = "updated_at"
        }
    }
}

