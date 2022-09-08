//
//  PostListResModel.swift
//  NadoSunbae
//
//  Created by hwangJi on 2022/09/08.
//

import Foundation

/// 커뮤니티 전체, 자유, 질문, 정보, 1:1 질문 전체 Post List 조회 Response Data Model
struct PostListResModel: Codable {
    let postID: Int
    let type, title, content, createdAt: String
    let majorName: String
    let writer: Writer
    let commentCount: Int
    let like: Like

    enum CodingKeys: String, CodingKey {
        case postID = "postId"
        case type, title, content, createdAt, majorName, writer, commentCount, like
    }
}
