//
//  AllSeriesModel.swift
//  Woow_Phase2
//
//  Created by Rahul Chopra on 23/07/22.
//

import Foundation

// MARK: - AllSeriesModel
struct AllSeriesModel: Codable {
    var success: Bool?
    var code: Int?
    var message: String?
    var body: [SeriesDetailModel.Series]?
}

