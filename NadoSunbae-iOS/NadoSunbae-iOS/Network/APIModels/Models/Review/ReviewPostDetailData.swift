//
//  ReviewPostDetailData.swift
//  NadoSunbae-iOS
//
//  Created by EUNJU on 2022/01/21.
//

import Foundation

// MARK: - ReviewPostDetailData
struct ReviewPostDetailData: Codable {
    let review: Review
    let writer: Writer
    let like: Like
    let backgroundImage: BackgroundImage
}

// MARK: - BackgroundImage
struct BackgroundImage: Codable {
    let imageID: Int

    enum CodingKeys: String, CodingKey {
        case imageID = "imageId"
    }
}

// MARK: - Review
struct Review: Codable {
    let id: Int
    let oneLineReview: String
    let contentList: [ContentList]
    let createdAt: String
}
