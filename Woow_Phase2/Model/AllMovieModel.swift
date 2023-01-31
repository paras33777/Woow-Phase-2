//
//  AllMovieModel.swift
//  Woow_Phase2
//
//  Created by Rahul Chopra on 14/03/22.
//

import Foundation

// MARK: - AllMovieModel
struct AllMovieModel: Codable {
    let success: Bool?
    let code: Int?
    let message: String?
    let body: [Body]?
    
    // MARK: - Body
    struct Body: Codable {
        let id: Int?
        let languageName, languageSlug, languageImage: String?
        let status: Int?
        var movies: [HomeContent.Content]?
        var isFavorite: Int?
        var isSelected: Bool = false

        enum CodingKeys: String, CodingKey {
            case id
            case languageName = "language_name"
            case languageSlug = "language_slug"
            case languageImage = "language_image"
            case status, movies
            case isFavorite = "is_favorite"
        }
    }
}
