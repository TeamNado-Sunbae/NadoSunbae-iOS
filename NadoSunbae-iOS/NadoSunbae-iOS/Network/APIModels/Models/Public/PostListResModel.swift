//
//  PostListResModel.swift
//  NadoSunbae
//
//  Created by hwangJi on 2022/09/08.
//

import Foundation

/// 커뮤니티 전체, 자유, 질문, 정보, 1:1 질문 전체 Post List 조회 Response Data Model
struct PostListResModel: Codable, Equatable {
    static func == (lhs: PostListResModel, rhs: PostListResModel) -> Bool {
        return (lhs.postID == rhs.postID && lhs.type == rhs.type && lhs.title == rhs.title && lhs.content == rhs.content && lhs.createdAt == rhs.createdAt && lhs.majorName == rhs.majorName && lhs.writer == rhs.writer && lhs.isAuthorized == rhs.isAuthorized && lhs.commentCount == rhs.commentCount && lhs.like == rhs.like)
    }
    
    let postID: Int
    let type: String?
    let title, content, createdAt: String
    let majorName: String
    let writer: CommunityWriter
    let isAuthorized: Bool?
    let commentCount: Int
    let like: Like

    enum CodingKeys: String, CodingKey {
        case postID = "postId"
        case type, isAuthorized, title, content, createdAt, majorName, writer, commentCount, like
    }
}


struct CommunityWriter: Codable, Equatable {
    let writerID: Int
    let nickname: String
    
    enum CodingKeys: String, CodingKey {
        case writerID = "id"
        case nickname
    }
}
