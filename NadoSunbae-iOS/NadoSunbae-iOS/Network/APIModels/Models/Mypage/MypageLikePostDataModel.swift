//
//  MypageLikePostDataModel.swift
//  NadoSunbae-iOS
//
//  Created by hwangJi on 2022/03/07.
//

import Foundation

// MARK: - MypageLikePostData
struct MypageLikePostData: Codable {
    let likePostList: [MypageLikePostDataModel]
}

// MARK: - MypageLikePostDataModel
struct MypageLikePostDataModel: Codable {
    let postID, postTypeID: Int
    let title, content, createdAt: String
    let writer: MypageLikeWriter
    let commentCount: Int
    let like: Like

    enum CodingKeys: String, CodingKey {
        case postID = "postId"
        case postTypeID = "postTypeId"
        case title, content, createdAt, writer, commentCount, like
    }
}

// MARK: - MypageLikeWriter
struct MypageLikeWriter: Codable {
    let writerID: Int
    let nickname: String

    enum CodingKeys: String, CodingKey {
        case writerID = "writerId"
        case nickname
    }
}
