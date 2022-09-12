//
//  PostDetailResModel.swift
//  NadoSunbae
//
//  Created by hwangJi on 2022/09/13.
//

import Foundation

// MARK: - PostDetailResModel
struct PostDetailResModel: Codable {
    let post: DetailPost
    let writer: PostDetailWriter
    let like: Like
    let commentCount: Int
    let commentList: [CommentList]
}

// MARK: - CommentList
struct CommentList: Codable {
    let commentID: Int
    let content, createdAt: String
    let isDeleted: Bool
    let writer: PostDetailWriter
    
    enum CodingKeys: String, CodingKey {
        case commentID = "id"
        case content, createdAt, isDeleted, writer
    }
}

// MARK: - Writer
struct PostDetailWriter: Codable {
    let writerID: Int
    let isPostWriter: Bool?
    let profileImageID: Int
    let nickname, firstMajorName, firstMajorStart, secondMajorName: String
    let secondMajorStart: String

    enum CodingKeys: String, CodingKey {
        case writerID = "id"
        case isPostWriter
        case profileImageID = "profileImageId"
        case nickname, firstMajorName, firstMajorStart, secondMajorName, secondMajorStart
    }
}

// MARK: - Post
struct DetailPost: Codable {
    let postDetailID: Int
    let title, content, createdAt, majorName: String
    
    enum CodingKeys: String, CodingKey {
        case postDetailID = "id"
        case title, content, createdAt, majorName
    }
}
