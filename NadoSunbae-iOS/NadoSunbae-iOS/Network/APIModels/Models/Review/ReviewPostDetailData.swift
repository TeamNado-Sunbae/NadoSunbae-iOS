//
//  ReviewPostDetailData.swift
//  NadoSunbae-iOS
//
//  Created by EUNJU on 2022/01/21.
//

import Foundation

// MARK: - PostDataClass
struct PostDataClass: Codable {
    let post: PostDetail
    let writer: PostWriter
    let like: Like
    let backgroundImage: BackgroundImage
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
    let postID: Int
    let oneLineReview: String
    let contentList: [PostContentList]
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case postID = "postId"
        case oneLineReview, contentList, createdAt
    }
}

// MARK: - PostContentList
struct PostContentList: Codable {
    let title, content: String
}

// MARK: - PostWriter
struct PostWriter: Codable {
    let writerID, profileImageID: Int
    let nickname, firstMajorName, firstMajorStart, secondMajorName: String
    let secondMajorStart: String
    let isOnQuestion, isReviewd: Bool

    enum CodingKeys: String, CodingKey {
        case writerID = "writerId"
        case profileImageID = "profileImageId"
        case nickname, firstMajorName, firstMajorStart, secondMajorName, secondMajorStart, isOnQuestion, isReviewd
    }
}
