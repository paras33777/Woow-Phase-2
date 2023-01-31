//
//  ChannelListModel.swift
//  Woow_Phase2
//
//  Created by Rahul Chopra on 14/03/22.
//

import Foundation

// MARK: - ChannelListModel
struct ChannelListModel: Codable {
    let success: Bool?
    let code: Int?
    let message: String?
    let body: [Body]?
    
    // MARK: - Body
    struct Body: Codable {
        let id: Int?
        let categoryName, categorySlug: String?
        let status: Int?
        let channelList: [ChannelList]?

        enum CodingKeys: String, CodingKey {
            case id
            case categoryName = "category_name"
            case categorySlug = "category_slug"
            case status, channelList
        }
    }
}



// MARK: - ChannelList
struct ChannelList: Codable {
    let id, channelCatID: Int?
    let channelAccess, channelName, channelSlug, channelDescription: String?
    let channelThumb, channelURLType: String?
    let channelURL, channelUrl2: String?
    let channelUrl3: String?
    let seoTitle, seoDescription, seoKeyword: String?
    let status: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case channelCatID = "channel_cat_id"
        case channelAccess = "channel_access"
        case channelName = "channel_name"
        case channelSlug = "channel_slug"
        case channelDescription = "channel_description"
        case channelThumb = "channel_thumb"
        case channelURLType = "channel_url_type"
        case channelURL = "channel_url"
        case channelUrl2 = "channel_url2"
        case channelUrl3 = "channel_url3"
        case seoTitle = "seo_title"
        case seoDescription = "seo_description"
        case seoKeyword = "seo_keyword"
        case status
    }
}
