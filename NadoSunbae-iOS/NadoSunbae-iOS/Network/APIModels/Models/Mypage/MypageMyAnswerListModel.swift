//
//  MypageMyAnswerListModel.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/02/19.
//

import Foundation

struct MypageMyAnswerListModel: Codable {
    var classroomPostListByMyCommentList: [MypageMyAnswerModel]
}

struct MypageMyAnswerModel: Codable {
    var postID: Int
    var title: String
    var content: String
    var createdAt: String
    var writer: Writer
    var like: Like
    var commentCount: Int

    enum CodingKeys: String, CodingKey {
        case postID = "postId"
        case title = "title"
        case content = "content"
        case createdAt = "createdAt"
        case writer = "writer"
        case like = "like"
        case commentCount = "commentCount"
    }
    
    struct Writer: Codable {
        var writerID: Int
        var nickname: String

        enum CodingKeys: String, CodingKey {
            case writerID = "writerId"
            case nickname = "nickname"
        }
    }
}
