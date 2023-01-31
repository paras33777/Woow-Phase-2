//
//  SearchModel.swift
//  Woow_Phase2
//
//  Created by Rahul Chopra on 23/03/22.
//

import Foundation


// MARK: - SearchListModel
struct SearchListModel: Codable {
    let success: Bool?
    let code: Int?
    let message: String?
    var body: Body?
    
    // MARK: - Body
    struct Body: Codable {
        var movies = [MovieDetailModel.Body]()
        var series = [SeriesModel]()
    }
}


/*
// MARK: - Movie
struct Movie: Codable {
    let id, creatorID: Int
    let videoAccess: VideoAccess
    let appType: AppType
    let webShow: WebShow
    let movieLangID: Int
    let movieGenreID, videoTitle: String
    let releaseDate: Int
    let duration: String?
    let videoDescription, videoSlug, videoImageThumb, videoImage: String
    let videoType: VideoType
    let videoQuality, familyContent: Int
    let videoURL: String
    let videoURL480, videoURL720, videoURL1080: String?
    let downloadEnable: Int?
    let downloadURL: String?
    let subtitleOnOff: Int?
    let subtitleLanguage1: String?
    let subtitleUrl1: String?
    let subtitleLanguage2: String?
    let subtitleUrl2: String?
    let subtitleLanguage3, subtitleUrl3, imdbID: JSONNull?
    let imdbRating: ImdbRating
    let imdbVotes: JSONNull?
    let seoTitle, seoDescription, seoKeyword: String
    let status: Int
    let createdAt: JSONNull?
    let updatedAt: String?
    let trailer: JSONNull?
    let adult: String

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
        case trailer, adult
    }
}

enum AppType: String, Codable {
    case both = "Both"
    case mini = "Mini"
    case woow = "Woow"
}

enum ImdbRating: String, Codable {
    case na = "NA"
    case notAvailable = "Not Available"
}

enum VideoAccess: String, Codable {
    case paid = "Paid"
}

enum VideoType: String, Codable {
    case url = "URL"
}

enum WebShow: String, Codable {
    case yes = "Yes"
}*/

// MARK: - Series
struct SeriesModel: Codable {
    let id, creatorID: Int
    let appType: AppType
    let webShow: WebShow
    let seriesLangID: Int
    let seriesGenres, seriesName, seriesSlug, seriesInfo: String
    let seriesPoster: String
    let imdbID: String?
    let imdbRating: String?
    let imdbVotes: String?
    let seoTitle, seoDescription, seoKeyword: String
    let status, familyContent: Int
    let trailer: String?
    let adult: String
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
        case status
        case familyContent = "family_content"
        case isFavorite = "is_favorite"
        case trailer, adult, type
    }
}
