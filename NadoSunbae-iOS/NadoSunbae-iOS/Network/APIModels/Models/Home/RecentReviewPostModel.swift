//
//  RecentReviewPostModel.swift
//  NadoSunbae
//
//  Created by EUNJU on 2022/09/23.
//

import Foundation

// MARK: - RecentReviewPostModel
struct RecentReviewPostModel: Codable {
    let id: Int
    let oneLineReview, majorName, createdAt: String
    let tagList: [ReviewTagList]
    let like: Like
}
