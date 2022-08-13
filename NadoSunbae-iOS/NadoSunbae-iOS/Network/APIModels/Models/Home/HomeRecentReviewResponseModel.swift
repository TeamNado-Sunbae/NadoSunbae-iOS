//
//  HomeRecentReviewResponseModel.swift
//  NadoSunbae
//
//  Created by madilyn on 2022/08/13.
//

import Foundation

struct HomeRecentReviewResponseModelElement: Codable {
    let id: Int
    let oneLineReview: String
    let majorName: String
    let createdAt: String
    let tagList: [ReviewTagList]
    let like: Like
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case oneLineReview = "oneLineReview"
        case majorName = "majorName"
        case createdAt = "createdAt"
        case tagList = "tagList"
        case like = "like"
    }
}

typealias HomeRecentReviewResponseModel = [HomeRecentReviewResponseModelElement]
