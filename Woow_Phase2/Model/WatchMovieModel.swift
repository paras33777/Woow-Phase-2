//
//  WatchMovieModel.swift
//  Woow_Phase2
//
//  Created by Rahul Chopra on 31/07/22.
//

import Foundation

// MARK: - WatchMovieModel
struct WatchMovieModel: Codable {
    var success: Bool?
    var code: Int?
    var message: String?
    var body: Body?
    
    // MARK: - Body
    struct Body: Codable {
        var id: Int?
        var videoType: String?
        var userID: Int?
        var videoID: Int?
        var watchTime: Int?

        enum CodingKeys: String, CodingKey {
            case id
            case videoType = "video_type"
            case userID = "user_id"
            case videoID = "video_id"
            case watchTime = "watch_time"
        }
    }
}


struct WatchSeriesModel: Codable {
    var success: Bool?
    var code: Int?
    var message: String?
    var body: Body?
    
    // MARK: - Body
    struct Body: Codable {
        var id: Int?
        var videoType: String?
        var userID: Int?
        var videoID: Int?
        var watchTime: Int?

        enum CodingKeys: String, CodingKey {
            case id
            case videoType = "video_type"
            case userID = "user_id"
            case videoID = "video_id"
            case watchTime = "watch_time"
        }
    }
}
