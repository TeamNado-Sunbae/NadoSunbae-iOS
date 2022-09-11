//
//  MypageMyReviewModel.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/02/22.
//

import Foundation

struct MypageMyReviewModel: Codable {
    var writer: Writer
    var reviewList: [MypageMyReviewPostModel]

    enum CodingKeys: String, CodingKey {
        case writer = "writer"
        case reviewList = "reviewList"
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

// MARK: - MypageMyReviewPostModel
struct MypageMyReviewPostModel: Codable {
    var id: Int
    var majorName: String
    var oneLineReview: String
    var createdAt: String
    var tagList: [ReviewTagList]
    var like: Like

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case majorName = "majorName"
        case oneLineReview = "oneLineReview"
        case createdAt = "createdAt"
        case tagList = "tagList"
        case like = "like"
    }
}
