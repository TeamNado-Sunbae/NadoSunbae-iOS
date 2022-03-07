//
//  MypageLikeReviewDataModel.swift
//  NadoSunbae-iOS
//
//  Created by hwangJi on 2022/03/08.
//

import Foundation

// MARK: - MypageLikeReviewData
struct MypageLikeReviewData: Codable {
    let likePostList: [MypageLikeReviewDataModel]
}

// MARK: - MypageLikeReviewDataModel
struct MypageLikeReviewDataModel: Codable {
    let postID: Int
    let title, createdAt: String
    let tagList: [ReviewTagList]
    let writer: MypageLikeWriter
    let like: Like

    enum CodingKeys: String, CodingKey {
        case postID = "postId"
        case title, createdAt, tagList, writer, like
    }
}
