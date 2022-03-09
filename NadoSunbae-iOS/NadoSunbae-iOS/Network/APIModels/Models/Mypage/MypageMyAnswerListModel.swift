//
//  MypageMyAnswerListModel.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/02/19.
//

import Foundation

// MARK: - MypageMyAnswerListModel
struct MypageMyAnswerListModel: Codable {
    let classroomPostListByMyCommentList: [MypageMyAnswerModel]
}

// MARK: - MypageMyAnswerModel
struct MypageMyAnswerModel: Codable {
    let postID,postTypeID: Int
    let title, content, createdAt: String
    let writer: Writer
    let like: Like
    let commentCount: Int

    enum CodingKeys: String, CodingKey {
        case postID = "postId"
        case postTypeID = "postTypeId"
        case title, content, createdAt, writer, like, commentCount
    }
    
    // MARK: - Writer
    struct Writer: Codable {
        let writerID: Int
        let nickname: String

        enum CodingKeys: String, CodingKey {
            case writerID = "writerId"
            case nickname
        }
    }
}
