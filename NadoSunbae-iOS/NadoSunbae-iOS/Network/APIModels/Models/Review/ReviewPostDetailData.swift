//
//  ReviewPostDetailData.swift
//  NadoSunbae-iOS
//
//  Created by EUNJU on 2022/01/21.
//

import Foundation

// MARK: - ReviewPostDetailData
struct ReviewPostDetailData: Codable {
    var post: PostDetail
    var writer: PostWriter
    var like: PostLike
    var backgroundImage: BackgroundImage
}

// MARK: - BackgroundImage
struct BackgroundImage: Codable {
    let imageID: Int
    let imageURL: String

    enum CodingKeys: String, CodingKey {
        case imageID = "imageId"
        case imageURL = "imageUrl"
    }
}

// MARK: - PostLike
struct PostLike: Codable {
    let isLiked: Bool
    let likeCount: String
}

// MARK: - PostDetail
struct PostDetail: Codable {
    var postID: Int = -1
    var oneLineReview: String = ""
    var contentList: [PostContent] = []
    var createdAt: String = ""

    enum CodingKeys: String, CodingKey {
        case postID = "postId"
        case oneLineReview, contentList, createdAt
    }
}

// MARK: - PostContentList
struct PostContent: Codable {
    var title: String = ""
    var content: String = ""
}

// MARK: - PostWriter
struct PostWriter: Codable {
    var writerID: Int = 0
    var profileImageID: Int = 0
    var nickname: String = ""
    var firstMajorName: String = ""
    var firstMajorStart: String = ""
    var secondMajorName: String = ""
    var secondMajorStart: String = ""
    var isOnQuestion: Bool = false
    var isReviewd: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case writerID = "writerId"
        case profileImageID = "profileImageId"
        case nickname = "nickname"
        case firstMajorName = "firstMajorName"
        case firstMajorStart = "firstMajorStart"
        case secondMajorName = "secondMajorName"
        case secondMajorStart = "secondMajorStart"
        case isOnQuestion = "isOnQuestion"
        case isReviewd = "isReviewd"
    }
}
