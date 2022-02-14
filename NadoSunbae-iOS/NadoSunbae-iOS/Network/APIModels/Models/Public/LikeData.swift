//
//  LikeData.swift
//  NadoSunbae-iOS
//
//  Created by EUNJU on 2022/01/19.
//

import Foundation

// MARK: - Like
struct Like: Codable {
    let isLiked: Bool
    let likeCount: Int
    
    enum CodingKeys: String, CodingKey {
        case isLiked, likeCount
    }
}
