//
//  MoviesListModel.swift
//  Woow_Phase2
//
//  Created by Rahul Chopra on 13/03/22.
//

import Foundation

// MARK: - MoviesListModel
struct MoviesListModel: Codable {
    var success: Bool?
    var code: Int?
    var message: String?
    var body: [HomeContent]?
}
