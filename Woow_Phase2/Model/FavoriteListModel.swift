//
//  FavoriteListModel.swift
//  Woow_Phase2
//
//  Created by Rahul Chopra on 12/05/22.
//

import Foundation

// MARK: - FavoriteListModel
struct FavoriteListModel: Codable {
    var success: Bool?
    var code: Int?
    var message: String?
    var body: [FavoriteModel]?
}

// MARK: - Body
struct FavoriteModel: Codable {
    var name: String?
    var id: Int?
    var image, bodyDescription, type: String?
    var isFavorite: Int?

    enum CodingKeys: String, CodingKey {
        case name, id, image
        case bodyDescription = "description"
        case type
        case isFavorite = "is_favorite"
    }
}
