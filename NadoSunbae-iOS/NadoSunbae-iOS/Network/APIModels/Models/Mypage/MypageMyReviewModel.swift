//
//  MypageMyReviewModel.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/02/22.
//

import Foundation

struct MypageMyReviewModel: Codable {
    var writer: Writer
    var reviewPostList: [MypageMyReviewPostModel]

    enum CodingKeys: String, CodingKey {
        case writer = "writer"
        case reviewPostList = "reviewPostList"
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

// MARK: - ReviewPostList
struct MypageMyReviewPostModel: Codable {
    var postID: Int
    var majorName: String
    var oneLineReview: String
    var createdAt: String
    var tagList: [TagList]
    var like: Like

    enum CodingKeys: String, CodingKey {
        case postID = "postId"
        case majorName = "majorName"
        case oneLineReview = "oneLineReview"
        case createdAt = "createdAt"
        case tagList = "tagList"
        case like = "like"
    }
    
    struct TagList: Codable {
        var tagName: String

        enum CodingKeys: String, CodingKey {
            case tagName = "tagName"
        }
    }
}
