//
//  FavoriteMajorPostResModel.swift
//  NadoSunbae
//
//  Created by EUNJU on 2022/10/27.
//

import Foundation

// MARK: - FavoriteMajorPostResModel
struct FavoriteMajorPostResModel: Codable {
    let majorID, userID: Int
    let isDeleted: Bool

    enum CodingKeys: String, CodingKey {
        case majorID = "majorId"
        case userID = "userId"
        case isDeleted
    }
}
