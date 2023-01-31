//
//  SeriesDetailModel.swift
//  Woow_Phase2
//
//  Created by Rahul Chopra on 17/05/22.
//

import Foundation

// MARK: - SeriesDetailModel
struct SeriesDetailModel: Codable {
    var success: Bool?
    var code: Int?
    var message: String?
    var body: Series?
    
    // MARK: - Body
    struct Series: Codable {
        var id, creatorID: Int?
        var appType, webShow: String?
        var seriesLangID: Int?
        var seriesGenres, seriesName, seriesSlug, seriesInfo: String?
        var seriesPoster: String?
        var imdbID: String?
        var imdbRating: String?
        var imdbVotes: String?
        var seoTitle, seoDescription, seoKeyword: String?
        var status, familyContent: Int?
        var trailer: String?
        var adult: String?
        var isFavorite: Int?
        var type: String?
        var subscription,is_liked_status,is_liked: Int?
        
        var seasonListing: [SeasonListing]?

        enum CodingKeys: String, CodingKey {
            case id
            case is_liked_status = "is_liked_status"
            case is_liked = "is_liked"
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
            case trailer, adult
            case isFavorite = "is_favorite"
            case seasonListing, type, subscription
        }
    }

    // MARK: - SeasonListing
    struct SeasonListing: Codable {
        var id, seriesID, creatorID: Int?
        var seasonName, seasonSlug, seasonPoster, seoTitle: String?
        var seoDescription, seoKeyword: String?
        var status: Int?
        var episodeListing: [EpisodeListing]?
        var isSelected: Bool = false

        enum CodingKeys: String, CodingKey {
            case id
            case seriesID = "series_id"
            case creatorID = "creator_id"
            case seasonName = "season_name"
            case seasonSlug = "season_slug"
            case seasonPoster = "season_poster"
            case seoTitle = "seo_title"
            case seoDescription = "seo_description"
            case seoKeyword = "seo_keyword"
            case status, episodeListing
        }
        
        // MARK: - EpisodeListing
        struct EpisodeListing: Codable {
            var id, creatorID: Int?
            var videoAccess: String?
            var episodeSeriesID, episodeSeasonID: Int?
            var videoTitle: String?
            var releaseDate: Int?
            var duration, videoDescription, videoSlug, videoImage: String?
            var videoType: String?
            var videoQuality: Int?
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
            var isSelected: Bool = false

            enum CodingKeys: String, CodingKey {
                case id
                case creatorID = "creator_id"
                case videoAccess = "video_access"
                case episodeSeriesID = "episode_series_id"
                case episodeSeasonID = "episode_season_id"
                case videoTitle = "video_title"
                case releaseDate = "release_date"
                case duration
                case videoDescription = "video_description"
                case videoSlug = "video_slug"
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
                case imdbID = "imdb_id"
                case imdbRating = "imdb_rating"
                case imdbVotes = "imdb_votes"
                case seoTitle = "seo_title"
                case seoDescription = "seo_description"
                case seoKeyword = "seo_keyword"
                case status
                case createdAt = "created_at"
                case updatedAt = "updated_at"
            }
        }
    }
}

