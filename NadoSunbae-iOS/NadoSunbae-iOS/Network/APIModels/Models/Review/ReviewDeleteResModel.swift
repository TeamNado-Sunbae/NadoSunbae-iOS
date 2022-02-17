//
//  ReviewDeleteResModel.swift
//  NadoSunbae-iOS
//
//  Created by EUNJU on 2022/02/17.
//

import Foundation

// MARK: - ReviewDeleteResModel
struct ReviewDeleteResModel: Codable {
    let postID: Int
    let isDeleted: Bool
    let isReviewed: Bool

    enum CodingKeys: String, CodingKey {
        case postID = "postId"
        case isDeleted, isReviewed
    }
}
