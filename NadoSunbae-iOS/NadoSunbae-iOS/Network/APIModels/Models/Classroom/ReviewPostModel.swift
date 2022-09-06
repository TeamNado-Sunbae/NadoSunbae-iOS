//
//  ReviewPostList.swift
//  NadoSunbae
//
//  Created by EUNJU on 2022/08/13.
//

import Foundation

// MARK: - ReviewPostModel
struct ReviewPostModel: Codable {
    var postId: Int
    var title: String
    var createdAt: String
    var writer: Writer
    var like: Like
    var tagList: [ReviewTagList]
    
    struct Writer: Codable {
        var writerId: Int
        var profileImageId: Int
        var nickname: String
    }
    
    struct Like: Codable {
        var isLiked: Bool
        var likeCount: Int
    }
}
