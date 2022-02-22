//
//  EditPostQuestionModel.swift
//  NadoSunbae-iOS
//
//  Created by hwangJi on 2022/02/23.
//

import Foundation

// MARK: - EditPostQuestionModel
struct EditPostQuestionModel: Codable {
    let post: EditedPostQuestion
    let writer: EditPostQuestionWriter
    let like: Like
}

// MARK: - EditedPost
struct EditedPostQuestion: Codable {
    let postID: Int
    let title, content, createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case postID = "postId"
        case title, content, createdAt, updatedAt
    }
}

// MARK: - EditPostQuestionWriter
struct EditPostQuestionWriter: Codable {
    let writerID, profileImageID: Int
    let nickname, firstMajorName, firstMajorStart, secondMajorName: String
    let secondMajorStart: String

    enum CodingKeys: String, CodingKey {
        case writerID = "writerId"
        case profileImageID = "profileImageId"
        case nickname, firstMajorName, firstMajorStart, secondMajorName, secondMajorStart
    }
}
