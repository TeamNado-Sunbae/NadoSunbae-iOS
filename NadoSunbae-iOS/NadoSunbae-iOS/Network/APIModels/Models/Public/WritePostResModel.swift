//
//  WritePostResModel.swift
//  NadoSunbae
//
//  Created by hwangJi on 2022/09/28.
//

import Foundation

struct WritePostResModel: Codable {
    let post: WritePost
    let writer: HomeRankingResponseModel.UserList
}

struct WritePost: Codable {
    let id: Int
    let type, title, content: String
    let majorID: Int
    let createdAt: String
    let answererID: Int
    
    enum CodingKeys: String, CodingKey {
        case id, type, title, content
        case majorID = "majorId"
        case createdAt
        case answererID = "answererId"
    }
}
