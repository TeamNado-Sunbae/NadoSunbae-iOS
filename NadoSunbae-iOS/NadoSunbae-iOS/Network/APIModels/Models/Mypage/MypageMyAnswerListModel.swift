//
//  MypageMyAnswerListModel.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/02/19.
//

import Foundation

// MARK: - MypageMyAnswerListModel
struct MypageMyAnswerListModel: Codable {
    var postList: [PostList]
    
    enum CodingKeys: String, CodingKey {
        case postList = "postList"
    }
    
    // MARK: - PostList
    struct PostList: Codable {
        var id: Int
        var type: String
        var title: String
        var content: String
        var createdAt: String
        var majorName: String
        var writer: MypageMyAnswerListModel.Writer
        var commentCount: Int
        var like: Like

        enum CodingKeys: String, CodingKey {
            case id = "id"
            case type = "type"
            case title = "title"
            case content = "content"
            case createdAt = "createdAt"
            case majorName = "majorName"
            case writer = "writer"
            case commentCount = "commentCount"
            case like = "like"
        }
    }
    
    // MARK: - Writer
    struct Writer: Codable {
        var id: Int
        var nickname: String

        enum CodingKeys: String, CodingKey {
            case id = "id"
            case nickname = "nickname"
        }
    }
}
