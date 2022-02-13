//
//  ReviewMainPostListData.swift
//  NadoSunbae-iOS
//
//  Created by EUNJU on 2022/01/20.
//

import Foundation

// MARK: - ReviewMainPostListData
struct ReviewMainPostListData: Codable {
    let postID: Int
    let oneLineReview: String
    let createdAt: String
    let writer: ReviewWriter
    let tagList: [ReviewTagList]
    let likeCount: Int

    enum CodingKeys: String, CodingKey {
        case postID = "postId"
        case oneLineReview, createdAt, writer, tagList, likeCount
    }
}

// MARK: - ReviewTagList
struct ReviewTagList: Codable {
    let tagName: String
}

// MARK: - ReviewWriter
struct ReviewWriter: Codable {
    let writerID, profileImageID: Int
    let nickname: String
    let firstMajorName: String
    let firstMajorStart: String
    let secondMajorName: String
    let secondMajorStart: String

    enum CodingKeys: String, CodingKey {
        case writerID = "writerId"
        case profileImageID = "profileImageId"
        case nickname, firstMajorName, firstMajorStart, secondMajorName, secondMajorStart
    }
}
