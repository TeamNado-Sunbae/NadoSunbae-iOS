//
//  PostLikeResModel.swift
//  NadoSunbae-iOS
//
//  Created by hwangJi on 2022/02/15.
//

import Foundation

// MARK: - PostLikeResModel
struct PostLikeResModel: Codable {
    let postID: Int
    let isLiked: Bool

    enum CodingKeys: String, CodingKey {
        case postID = "targetId"
        case isLiked
    }
}
