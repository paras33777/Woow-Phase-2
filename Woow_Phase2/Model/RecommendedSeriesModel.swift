//
//  RecommendedSeriesModel.swift
//  Woow_Phase2
//
//  Created by Rahul Chopra on 19/06/22.
//

import Foundation

// MARK: - RecommendedSeriesModel
struct RecommendedSeriesModel: Codable {
    var success: Bool?
    var code: Int?
    var message: String?
    var body: [Body]?
    
    // MARK: - Body
    struct Body: Codable {
        var id, creatorID: Int?
        var appType, webShow: String?
        var seriesLangID: Int?
        var seriesGenres, seriesName, seriesSlug, seriesInfo: String?
        var seriesPoster: String?
        var imdbID: String?
        var imdbRating: String?
        var imdbVotes: String?
        var seoTitle, seoDescription, seoKeyword: String?
        var status, familyContent, location: Int?
        var countryValue, trailer: String?
        var adult: String?

        enum CodingKeys: String, CodingKey {
            case id
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
            case status
            case familyContent = "family_content"
            case location
            case countryValue = "country_value"
            case trailer, adult
        }
    }
}
