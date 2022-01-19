//
//  ReviewPostData.swift
//  NadoSunbae-iOS
//
//  Created by EUNJU on 2022/01/19.
//

import Foundation

// MARK: - ReviewPost
struct ReviewPost: Codable {
    let reviewPostID: Int
    let oneLineReview: String
    let contentList: [ContentList]
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case reviewPostID = "postId"
        case oneLineReview, contentList, createdAt
    }
}
