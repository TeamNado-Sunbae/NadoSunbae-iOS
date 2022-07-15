//
//  CommunityPostList.swift
//  NadoSunbae
//
//  Created by hwangJi on 2022/07/15.
//

import Foundation

// MARK: - CommunityPostList
struct CommunityPostList: Codable {
    var category: String = ""
    var postID: Int = 0
    var title: String = ""
    var content: String = ""
    var createdAt: String = ""
    var writer: Writer = Writer()
    var like: Like = Like(isLiked: true, likeCount: 0)
    var commentCount: Int = 0

    enum CodingKeys: String, CodingKey {
        case category = "category"
        case postID = "postId"
        case title = "title"
        case content = "content"
        case createdAt = "createdAt"
        case writer = "writer"
        case commentCount = "commentCount"
        case like = "like"
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
