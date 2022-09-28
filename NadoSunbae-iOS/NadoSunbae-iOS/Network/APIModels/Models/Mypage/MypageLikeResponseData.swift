//
//  MypageLikeReviewDataModel.swift
//  NadoSunbae-iOS
//
//  Created by hwangJi on 2022/03/08.
//

import Foundation

// MARK: - MypageLikeListResponseData
struct MypageLikeReviewListModel: Codable {
    var likeList: [MypageLikeReviewListModel.LikeList]
    
    enum CodingKeys: String, CodingKey {
        case likeList = "likeList"
    }
    
    // MARK: - LikeList
    struct LikeList: Codable {
        var id: Int
        var title: String
        var createdAt: String
        var tagList: [ReviewTagList]
        var writer: Writer
        var like: Like
        
        enum CodingKeys: String, CodingKey {
            case id = "id"
            case title = "title"
            case createdAt = "createdAt"
            case tagList = "tagList"
            case writer = "writer"
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

struct MypageLikeQuestionToPersonListModel: Codable {
    var likeList: [MypageLikeQuestionToPersonListModel.LikeList]
    
    enum CodingKeys: String, CodingKey {
        case likeList = "likeList"
    }
    
    // MARK: - LikeList
    struct LikeList: Codable {
        var id: Int
        var title: String
        var content: String
        var createdAt: String
        var majorName: String
        var writer: Writer
        var commentCount: Int
        var like: Like
        
        enum CodingKeys: String, CodingKey {
            case id = "id"
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

// MARK: - MypageLikeCommunityListModel
struct MypageLikeCommunityListModel: Codable {
    var likeList: [MypageLikeCommunityListModel.LikeList]

    enum CodingKeys: String, CodingKey {
        case likeList = "likeList"
    }
    
    // MARK: - LikeList
    struct LikeList: Codable {
        var id: Int
        var type: String
        var title: String
        var content: String
        var createdAt: String
        var majorName: String
        var writer: Writer
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
}
