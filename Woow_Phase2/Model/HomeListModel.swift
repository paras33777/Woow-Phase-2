//
//  HomeListModel.swift
//  Woow_Phase2
//
//  Created by Rahul Chopra on 17/02/22.
//

import Foundation
import AVKit

// MARK: - HomeListModel
struct HomeListModel: Codable {
    let success: Bool?
    let code: Int?
    let message: String?
    let body: Body?
    
    // MARK: - Body
    struct Body: Codable {
        let banner: [Banner]?
        var recentlyWatched: [RecentlyWatched]?
        let homeContent: [HomeContent]?
        let builds:Build?

        enum CodingKeys: String, CodingKey {
            case banner = "Banner"
            case recentlyWatched = "recently_watched"
            case homeContent = "HomeContent"
            case builds = "Build"

        }
    }

}

// MARK: - BUILDS
struct Build: Codable {
    let ios_build, android_build: String?
    
    enum CodingKeys: String, CodingKey {
        case ios_build, android_build
    }
}

// MARK: - RecentlyWatched
struct RecentlyWatched: Codable {
    var id: Int?
    var type, title, image, adult, videoDescription,access_message: String?
    var videoType: VideoTypeEnum?

    enum CodingKeys: String, CodingKey {
        case id, type, title, image, adult,access_message
        case videoType = "video_type"
        case videoDescription = "video_description"
    }
}

enum VideoTypeEnum: String, Codable {
    case free = "Free"
    case premium = "premium"
}

// MARK: - Banner
struct Banner: Codable {
    let id: Int?
    let title, bannerDescription: String?
    let thumbnail: String?
    let videoURL: String?
    let url, app, tv, bannerType: String?
    var bannerPostID: Int?
    let appSlot, tvSlot: Int?
    let status, createdAt, updatedAt: String?
    var player : AVPlayer?
    var isPlayed: Bool = false

    enum CodingKeys: String, CodingKey {
        case id, title
        case bannerDescription = "description"
        case thumbnail
        case videoURL = "video_url"
        case url, app, tv
        case appSlot = "app_slot"
        case tvSlot = "tv_slot"
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case bannerType = "banner_type"
        case bannerPostID = "banner_post_id"
    }
}

// MARK: - HomeContent
struct HomeContent: Codable {
    let id: Int?
    let title, type, values, isEditable: String?
    let app, tv: String?
    let appSlot, tvSlot: Int?
    let status, createdAt, updatedAt: String?
    var content: [Content]?

    enum CodingKeys: String, CodingKey {
        case id, title, type, values
        case isEditable = "is_editable"
        case app, tv
        case appSlot = "app_slot"
        case tvSlot = "tv_slot"
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case content
    }
    
    // MARK: - Content
    struct Content: Codable {
        let id: Int?
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
        let videoAccess: VideoAccess?
        let movieLangID: Int?
        let movieGenreID, videoTitle: String?
        let releaseDate: Int?
        let duration, videoDescription, videoSlug, videoImageThumb: String?
        let videoImage: String?
        let videoType: VideoType?
        let videoQuality: Int?
        let videoURL: String?
        let videoURL480, videoURL720, videoURL1080: String?
        let downloadEnable: Int?
        let downloadURL: String?
        let subtitleOnOff: Int?
        let subtitleLanguage1: String?
        let subtitleUrl1: String?
        let subtitleLanguage2: String?
        let subtitleUrl2: String?
        let subtitleLanguage3, subtitleUrl3, createdAt, adult: String?
        let updatedAt, type,access_message: String?
        var isFavorite: Int?
        var isMovie: Bool = true
        var isShown: Bool = false

        enum CodingKeys: String, CodingKey {
            case id
            case access_message = "access_message"
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
            case videoAccess = "video_access"
            case movieLangID = "movie_lang_id"
            case movieGenreID = "movie_genre_id"
            case videoTitle = "video_title"
            case releaseDate = "release_date"
            case duration, type
            case videoDescription = "video_description"
            case videoSlug = "video_slug"
            case videoImageThumb = "video_image_thumb"
            case videoImage = "video_image"
            case videoType = "video_type"
            case videoQuality = "video_quality"
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
            case createdAt = "created_at"
            case updatedAt = "updated_at"
            case adult = "adult"
            case isFavorite = "is_favorite"
        }
    }
}


enum AppType: String, Codable {
    case both = "Both"
    case woow = "Woow"
    case mini = "Mini"
}

enum VideoAccess: String, Codable {
    case paid = "Paid"
}

enum VideoType: String, Codable {
    case url = "URL"
}

enum WebShow: String, Codable {
    case yes = "Yes"
}
