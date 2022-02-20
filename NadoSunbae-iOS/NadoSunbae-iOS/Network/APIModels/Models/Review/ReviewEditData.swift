//
//  ReviewEditData.swift
//  NadoSunbae-iOS
//
//  Created by EUNJU on 2022/02/18.
//

import Foundation

// MARK: - ReviewEditData
struct ReviewEditData: Codable {
    let post: EditedPost
    let writer: Editer
    let like: Like
    let backgroundImage: ReviewPostBackgroundImg
}

// MARK: - EditedPost
struct EditedPost: Codable {
    let postID: Int
    let oneLineReview: String
    let contentList: [ContentList]
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case postID = "postId"
        case oneLineReview, contentList, createdAt, updatedAt
    }
}

// MARK: - Editer
struct Editer: Codable {
    let editerID, profileImageID: Int
    let nickname, firstMajorName, firstMajorStart, secondMajorName: String
    let secondMajorStart: String

    enum CodingKeys: String, CodingKey {
        case editerID = "writerId"
        case profileImageID = "profileImageId"
        case nickname, firstMajorName, firstMajorStart, secondMajorName, secondMajorStart
    }
}
