//
//  MypageMyPostListModel.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/02/18.
//

import Foundation

struct MypageMyPostListModel: Codable {
    var classroomPostList: [MypageMyPostModel]

    enum CodingKeys: String, CodingKey {
        case classroomPostList = "classroomPostList"
    }
}

struct MypageMyPostModel: Codable {
    var postID: Int
    var title: String
    var content: String
    var majorName: String
    var createdAt: String
    var commentCount: Int
    var like: Like

    enum CodingKeys: String, CodingKey {
        case postID = "postId"
        case title = "title"
        case content = "content"
        case majorName = "majorName"
        case createdAt = "createdAt"
        case commentCount = "commentCount"
        case like = "like"
    }
}

enum MypageMyPostType: String {
    case question = "question"
    case information = "information"
}
