//
//  RecommendedMoviesModel.swift
//  Woow_Phase2
//
//  Created by Rahul Chopra on 19/06/22.
//

import Foundation
import UIKit

// MARK: - RecommendedMoviesModel
struct RecommendedMoviesModel: Codable {
    var success: Bool?
    var code: Int?
    var message: String?
    var body: [Body]?
    
    // MARK: - Body
    struct Body: Codable {
        var id, creatorID: Int?
        var videoAccess, appType, webShow: String?
        var movieLangID: Int?
        var movieGenreID, videoTitle: String?
        var releaseDate: Int?
        var duration, videoDescription, videoSlug, videoImageThumb: String?
        var videoImage, videoType: String?
        var videoQuality, familyContent: Int?
        var videoURL: String?
        var videoURL480, videoURL720, videoURL1080: String?
        var downloadEnable: Int?
        var downloadURL: String?
        var subtitleOnOff: Int?
        var subtitleLanguage1, subtitleUrl1, subtitleLanguage2, subtitleUrl2: String?
        var subtitleLanguage3, subtitleUrl3, imdbID: String?
        var imdbRating: String?
        var imdbVotes: String?
        var seoTitle, seoDescription, seoKeyword: String?
        var status: Int?
        var createdAt: String?
        var updatedAt: String?
        var location: Int?
        var countryValue, trailer: String?
        var adult: String?

        enum CodingKeys: String, CodingKey {
            case id
            case creatorID = "creator_id"
            case videoAccess = "video_access"
            case appType = "app_type"
            case webShow = "web_show"
            case movieLangID = "movie_lang_id"
            case movieGenreID = "movie_genre_id"
            case videoTitle = "video_title"
            case releaseDate = "release_date"
            case duration
            case videoDescription = "video_description"
            case videoSlug = "video_slug"
            case videoImageThumb = "video_image_thumb"
            case videoImage = "video_image"
            case videoType = "video_type"
            case videoQuality = "video_quality"
            case familyContent = "family_content"
            case videoURL = "video_url"
            case videoURL480 = "video_url_480"
            case videoURL720 = "video_url_720"
            case videoURL1080 = "video_url_1080"
            case downloadEnable = "download_enable"
            case downloadURL = "download_url"
            case subtitleOnOff = "subtitle_on_off"
            case subtitleLanguage1 = "subtitle_language1"
            case subtitleUrl1 = "subtitle_url1"
            case subtitleLanguage2 = "subtitle_language2"
            case subtitleUrl2 = "subtitle_url2"
            case subtitleLanguage3 = "subtitle_language3"
            case subtitleUrl3 = "subtitle_url3"
            case imdbID = "imdb_id"
            case imdbRating = "imdb_rating"
            case imdbVotes = "imdb_votes"
            case seoTitle = "seo_title"
            case seoDescription = "seo_description"
            case seoKeyword = "seo_keyword"
            case status
            case createdAt = "created_at"
            case updatedAt = "updated_at"
            case location
            case countryValue = "country_value"
            case trailer, adult
        }
    }
}
