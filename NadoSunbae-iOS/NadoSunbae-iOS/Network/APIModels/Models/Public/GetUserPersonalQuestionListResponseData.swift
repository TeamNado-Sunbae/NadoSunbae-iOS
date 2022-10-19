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
        var isAuthorized: Bool?
        var commentCount: Int
        var like: Like

        enum CodingKeys: String, CodingKey {
            case postID = "postId"
            case title, content, createdAt, writer, isAuthorized, commentCount, like
        }
    }
}
