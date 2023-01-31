//
//  SeriesListModel.swift
//  Woow_Phase2
//
//  Created by Rahul Chopra on 28/03/22.
//

import Foundation

// MARK: - SeriesListModel
struct SeriesListModel: Codable {
    let success: Bool?
    let code: Int?
    let message: String?
    let body: [Body]?
    
    // MARK: - Body
    struct Body: Codable {
        let id: Int?
        let title, type, values, isEditable: String?
        let app, tv: String?
        let appSlot, tvSlot: Int?
        let createdAt, updatedAt: String?
        var content: [Content]?
//        let status: String?

        enum CodingKeys: String, CodingKey {
            case id, title, type, values
            case isEditable = "is_editable"
            case app, tv
            case appSlot = "app_slot"
            case tvSlot = "tv_slot"
//            case status
            case createdAt = "created_at"
            case updatedAt = "updated_at"
            case content
        }
    }

    // MARK: - Content
    struct Content: Codable {
        let id, creatorID: Int?
        let appType: AppType?
        let webShow: WebShow?
        let seriesLangID: Int?
        let seriesGenres, seriesName, seriesSlug, seriesInfo: String?
        let seriesPoster: String?
        let imdbID: String?
        let imdbRating: String?
        let imdbVotes: String?
        let seoTitle, seoDescription, seoKeyword: String?
        let status, familyContent: Int?
        let trailer: String?
        let adult: String?
        var type,access_message: String?
        var isFavorite: Int?
        var isShown: Bool = false

        enum CodingKeys: String, CodingKey {
            case id
            case access_message = "access_message"
            case creatorID = "creator_id"
            case appType = "app_type"
            case webShow = "web_show"
            case seriesLangID = "series_lang_id"
            case seriesGenres = "series_genres"
            case seriesName = "series_name"
            case seriesSlug = "series_slug"
            case seriesInfo = "series_info"
            case seriesPoster = "series_poster"
            case imdbID = "imdb_id"
            case imdbRating = "imdb_rating"
            case imdbVotes = "imdb_votes"
            case seoTitle = "seo_title"
            case seoDescription = "seo_description"
            case seoKeyword = "seo_keyword"
            case status, type
            case familyContent = "family_content"
            case trailer, adult
            case isFavorite = "is_favorite"
        }
    }

}
