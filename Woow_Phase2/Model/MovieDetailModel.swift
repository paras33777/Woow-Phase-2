//
//  MovieDetailModel.swift
//  Woow_Phase2
//
//  Created by Rahul Chopra on 18/02/22.
//

import Foundation

// MARK: - MovieDetailModel
struct MovieDetailModel: Codable {
    let success: Bool
    let code: Int
    let message: String
    var body: Body
    
    // MARK: - Body
    struct Body: Codable {
        let id: Int?
        let videoAccess, appType, webShow: String?
        let movieLangID: Int?
        let movieGenreID, videoTitle: String?
        let releaseDate: Int?
        let duration, videoDescription, videoSlug, videoImageThumb: String?
        let videoImage, videoType: String?
        let videoQuality, familyContent: Int?
        let videoURL: String?
        let videoURL480, videoURL720, videoURL1080: String?
        let downloadEnable: Int?
        let downloadURL: String?
        let subtitleOnOff: Int?
        let subtitleLanguage1, subtitleUrl1, subtitleLanguage2, subtitleUrl2: String?
        let subtitleLanguage3, subtitleUrl3, imdbID: String?
        let imdbRating: String
        let imdbVotes: String?
        let seoTitle, seoDescription, seoKeyword: String?
        let status: Int?
        let createdAt: String?
        let updatedAt: String?
        var isFavorite: Int?
        var trailer: String?
        var adult: String?
        var type,access_message: String?
        var subscription,is_liked,is_liked_status: Int?
        var isShown: Bool = false
        
        enum CodingKeys: String, CodingKey {
            case id
            case is_liked_status = "is_liked_status"
            case is_liked = "is_liked"
            case videoAccess = "video_access"
            case access_message = "access_message"
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
            case status, trailer, type
            case createdAt = "created_at"
            case updatedAt = "updated_at"
            case isFavorite = "is_favorite"
            case adult = "adult"
            case subscription
        }
    }
}
