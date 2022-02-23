//
//  EditPostCommentModel.swift
//  NadoSunbae-iOS
//
//  Created by hwangJi on 2022/02/24.
//

import Foundation

// MARK: - EditPostCommentModel
struct EditPostCommentModel: Codable {
    let commentID, postID: Int
    let content, createdAt, updatedAt: String
    let isDeleted: Bool
    let writer: EditPostWriter

    enum CodingKeys: String, CodingKey {
        case commentID = "commentId"
        case postID = "postId"
        case content, createdAt, updatedAt, isDeleted, writer
    }
}
