//
//  AddCommentData.swift
//  NadoSunbae-iOS
//
//  Created by hwangJi on 2022/01/21.
//

import Foundation

// MARK: - AddCommentData
struct AddCommentData: Codable {
    let commentID, postID: Int
    let content, createdAt: String
    let isDeleted: Bool
    let writer: AddCommentWriter

    enum CodingKeys: String, CodingKey {
        case commentID = "commentId"
        case postID = "postId"
        case content, createdAt, isDeleted, writer
    }
}

// MARK: - Writer
struct AddCommentWriter: Codable {
    let writerID, profileImageID: Int
    let nickname, firstMajorName, firstMajorStart, secondMajorName: String
    let secondMajorStart: String

    enum CodingKeys: String, CodingKey {
        case writerID = "writerId"
        case profileImageID = "profileImageId"
        case nickname, firstMajorName, firstMajorStart, secondMajorName, secondMajorStart
    }
}
