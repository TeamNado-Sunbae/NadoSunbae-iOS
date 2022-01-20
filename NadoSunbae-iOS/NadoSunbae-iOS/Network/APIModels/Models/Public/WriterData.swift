//
//  WriterData.swift
//  NadoSunbae-iOS
//
//  Created by EUNJU on 2022/01/19.
//

import Foundation

// MARK: - Writer
struct Writer: Codable {
    let writerID: Int
    let nickname, firstMajorName, firstMajorStart, secondMajorName: String
    let secondMajorStart: String
    let isOnQuestion, isReviewed: Bool
    let profileImageId: Int

    enum CodingKeys: String, CodingKey {
        case writerID = "writerId"
        case nickname, firstMajorName, firstMajorStart, secondMajorName, secondMajorStart, isOnQuestion, isReviewed, profileImageId
    }
}
