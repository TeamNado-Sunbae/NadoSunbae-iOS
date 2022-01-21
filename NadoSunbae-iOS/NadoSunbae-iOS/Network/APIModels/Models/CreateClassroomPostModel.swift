//
//  CreateClassroomPostModel.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/01/21.
//

import Foundation

struct CreateClassroomPostModel: Codable {
    var post: Post
    var writer: Writer

    enum CodingKeys: String, CodingKey {
        case post = "post"
        case writer = "writer"
    }
    
    struct Post: Codable {
        var postID: Int
        var title: String
        var content: String
        var createdAt: String
        var answererID: Int?
        var postTypeID: Int

        enum CodingKeys: String, CodingKey {
            case postID = "postId"
            case title = "title"
            case content = "content"
            case createdAt = "createdAt"
            case answererID = "answererId"
            case postTypeID = "postTypeId"
        }
    }

    struct Writer: Codable {
        var writerID: Int
        var profileImageID: Int
        var nickname: String
        var firstMajorName: String
        var firstMajorStart: String
        var secondMajorName: String
        var secondMajorStart: String

        enum CodingKeys: String, CodingKey {
            case writerID = "writerId"
            case profileImageID = "profileImageId"
            case nickname = "nickname"
            case firstMajorName = "firstMajorName"
            case firstMajorStart = "firstMajorStart"
            case secondMajorName = "secondMajorName"
            case secondMajorStart = "secondMajorStart"
        }
    }
}
