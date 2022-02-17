//
//  InfoDetailDataModel.swift
//  NadoSunbae-iOS
//
//  Created by hwangJi on 2022/02/15.
//

import Foundation

// MARK: - InfoDetailDataModel
struct InfoDetailDataModel: Codable {
    let post: InfoDetailPost
    let writer: InfoDetailWriter
    let like: Like
    let commentCount: Int
    let commentList: [InfoDetailCommentList]
}

// MARK: - InfoDetailCommentList
struct InfoDetailCommentList: Codable {
    let commentID: Int
    let content, createdAt: String
    let isDeleted: Bool
    let writer: InfoDetailWriter

    enum CodingKeys: String, CodingKey {
        case commentID = "commentId"
        case content, createdAt, isDeleted, writer
    }
}

// MARK: - InfoDetailWriter
struct InfoDetailWriter: Codable {
    let writerID, profileImageID: Int
    let nickname, firstMajorName, firstMajorStart, secondMajorName: String
    let secondMajorStart: String
    let isPostWriter: Bool?

    enum CodingKeys: String, CodingKey {
        case writerID = "writerId"
        case profileImageID = "profileImageId"
        case nickname, firstMajorName, firstMajorStart, secondMajorName, secondMajorStart, isPostWriter
    }
}

// MARK: - InfoDetailPost
struct InfoDetailPost: Codable {
    let postID: Int
    let title, content, createdAt: String

    enum CodingKeys: String, CodingKey {
        case postID = "postId"
        case title, content, createdAt
    }
}
