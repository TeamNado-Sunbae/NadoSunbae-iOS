//
//  ReviewPostRegisterData.swift
//  NadoSunbae-iOS
//
//  Created by EUNJU on 2022/01/19.
//

import Foundation

// MARK: - ReviewPostRegisterData
struct ReviewPostRegisterData: Codable {
    let post: ReviewPost
    let writer: Writer
    let like: Like
    let backgroundImage: ReviewPostBackgroundImg
}

// MARK: - ReviewPostBackgroundImg
struct ReviewPostBackgroundImg: Codable {
    let imgID: Int
    let imgURL: ReviewPostImageURL

    enum CodingKeys: String, CodingKey {
        case imgID = "imageId"
        case imgURL = "imageUrl"
    }
}

// MARK: - ImageURL
struct ReviewPostImageURL: Codable {
    let imgURL: String

    enum CodingKeys: String, CodingKey {
        case imgURL = "imageUrl"
    }
}

// MARK: - ContentList
struct ContentList: Codable {
    let title, content: String
}
