//
//  ReviewEditData.swift
//  NadoSunbae-iOS
//
//  Created by EUNJU on 2022/02/18.
//

import Foundation

// MARK: - ReviewEditData
struct ReviewEditData: Codable {
    let id: Int
    let oneLineReview: String
    let contentList: [ContentList]
    let createdAt, updatedAt: String
    let writer: ReviewWriter
    let like: Like
    let backgroundImage: BackgroundImage
}
