//
//  HomeRecentReviewResponseModel.swift
//  NadoSunbae
//
//  Created by madilyn on 2022/08/13.
//

import Foundation

struct HomeRecentReviewResponseDataElement: Codable {
    var id: Int
    var oneLineReview: String
    var majorName: String
    var createdAt: String
    var tagList: [ReviewTagList]
    var like: Like

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case oneLineReview = "oneLineReview"
        case majorName = "majorName"
        case createdAt = "createdAt"
        case tagList = "tagList"
        case like = "like"
    }
}

typealias HomeRecentReviewResponseData = [HomeRecentReviewResponseDataElement]
