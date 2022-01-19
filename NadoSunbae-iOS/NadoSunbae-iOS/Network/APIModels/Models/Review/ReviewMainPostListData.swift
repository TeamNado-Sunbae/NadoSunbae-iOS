//
//  ReviewMainPostListData.swift
//  NadoSunbae-iOS
//
//  Created by EUNJU on 2022/01/20.
//

import Foundation

// MARK: - ReviewMainPostListData
struct ReviewMainPostListData: Codable {
    let reviewPostID: Int
    let oneLineReview, createdAt: String
    let reviewWriter: Writer
    let reviewTagList: [ReviewTagList]
    let reviewLikeCount: String

    enum CodingKeys: String, CodingKey {
        case reviewPostID = "postId"
        case oneLineReview, createdAt, reviewWriter, reviewTagList, reviewLikeCount
    }
}

// MARK: - ReviewTagList
struct ReviewTagList: Codable {
    let tagName: TagName
}

enum TagName: String, Codable {
    case tip = "꿀팁"
    case curriculum = "뭘 배우나요?"
    case futureCareer = "향후 진로"
}
