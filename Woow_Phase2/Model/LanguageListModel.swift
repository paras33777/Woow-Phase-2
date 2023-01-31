//
//  LanguageListModel.swift
//  Woow_Phase2
//
//  Created by Rahul Chopra on 24/07/22.
//

import Foundation


// MARK: - LanguageListModel
struct LanguageListModel: Codable {
    var success: Bool?
    var code: Int?
    var message: String?
    var body: [Body]?
    
    // MARK: - Body
    struct Body: Codable {
        var id: Int?
        var languageName, languageSlug: String?
        var languageImage: String?
        var status: Int?
        var isSelected: Bool = false
        
        enum CodingKeys: String, CodingKey {
            case id
            case languageName = "language_name"
            case languageSlug = "language_slug"
            case languageImage = "language_image"
            case status
        }
    }

}
