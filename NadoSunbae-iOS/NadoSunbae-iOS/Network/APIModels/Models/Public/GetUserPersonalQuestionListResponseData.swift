//
//  MypageUserPersonalQuestionModel.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/01/19.
//

import Foundation

// MARK: - QuestionOrInfoListModel
struct GetUserPersonalQuestionListResponseData: Codable {
    var postList: [PostList]
    
    // MARK: - PostList
    struct PostList: Codable {
        var postID: Int
        var title, content, createdAt: String
        var writer: CommunityWriter
        var commentCount: Int
        var like: Like

        enum CodingKeys: String, CodingKey {
            case postID = "postId"
            case title, content, createdAt, writer, commentCount, like
        }
    }
}

// MARK: - PostList
struct ClassroomPostList: Codable {
    var postID: Int = 0
    var title: String = ""
    var content: String = ""
    var createdAt: String = ""
    var writer: Writer = Writer(writerID: 0, nickname: "", firstMajorName: "", firstMajorStart: "", secondMajorName: "", secondMajorStart: "", isOnQuestion: false, isReviewed: false, profileImageId: 1)
    var like: Like = Like(isLiked: true, likeCount: 0)
    var commentCount: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case postID = "postId"
        case title = "title"
        case content = "content"
        case createdAt = "createdAt"
        case writer = "writer"
        case commentCount = "commentCount"
        case like = "like"
    }
}
