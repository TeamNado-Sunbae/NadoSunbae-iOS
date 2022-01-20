//
//  MypageUserPersonalQuestionModel.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/01/19.
//

import Foundation

// MARK: - QuestionOrInfoListModel
struct QuestionOrInfoListModel: Codable {
    var classroomPostList: [ClassroomPostList] = []

    enum CodingKeys: String, CodingKey {
        case classroomPostList = "classroomPostList"
    }
}

// MARK: - PostList
struct ClassroomPostList: Codable {
    var postID: Int = 0
    var title: String = ""
    var content: String = ""
    var createdAt: String = ""
    var writer: Writer = Writer()
    var commentCount: String = ""
    var likeCount: String = ""

    enum CodingKeys: String, CodingKey {
        case postID = "postId"
        case title = "title"
        case content = "content"
        case createdAt = "createdAt"
        case writer = "writer"
        case commentCount = "commentCount"
        case likeCount = "likeCount"
    }
    
    struct Writer: Codable {
        var writerID: Int = 0
        var profileImageID: Int = 0
        var nickname: String = ""

        enum CodingKeys: String, CodingKey {
            case writerID = "writerId"
            case profileImageID = "profileImageId"
            case nickname = "nickname"
        }
    }
}

var questionList: [ClassroomPostList] = [
    ClassroomPostList()
]
