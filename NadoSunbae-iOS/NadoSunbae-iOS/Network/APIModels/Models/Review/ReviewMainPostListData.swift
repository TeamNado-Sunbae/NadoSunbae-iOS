//
//  ReviewMainPostListData.swift
//  NadoSunbae-iOS
//
//  Created by EUNJU on 2022/01/20.
//

import Foundation
import UIKit

let screenSize: CGRect = UIScreen.main.bounds
let screenWidth = screenSize.width

// MARK: - ReviewMainPostListData
struct ReviewMainPostListData: Codable {
    let postID: Int
    let oneLineReview: String
    let createdAt: String
    let writer: ReviewWriter
    let tagList: [ReviewTagList]
    let like: Like

    enum CodingKeys: String, CodingKey {
        case postID = "id"
        case oneLineReview, createdAt, writer, tagList, like
    }
}

// MARK: - ReviewTagList
struct ReviewTagList: Codable {
    let tagName: String
}

// MARK: - ReviewWriter
struct ReviewWriter: Codable {
    let writerID, profileImageID: Int
    let nickname: String
    let firstMajorName: String
    let firstMajorStart: String
    let secondMajorName: String
    let secondMajorStart: String

    enum CodingKeys: String, CodingKey {
        case writerID = "writerId"
        case profileImageID = "profileImageId"
        case nickname, firstMajorName, firstMajorStart, secondMajorName, secondMajorStart
    }
}
