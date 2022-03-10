//
//  SignInModel.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/01/20.
//

import Foundation

struct SignInDataModel: Codable {
    var user: User
    var accesstoken: String
    var refreshtoken: String

    enum CodingKeys: String, CodingKey {
        case user = "user"
        case accesstoken = "accesstoken"
        case refreshtoken = "refreshtoken"
    }
    
    struct User: Codable {
        var userID: Int
        var email: String
        var universityID: Int
        var firstMajorID: Int
        var firstMajorName: String
        var secondMajorID: Int
        var secondMajorName: String
        var isReviewed: Bool
        var isEmailVerified: Bool
        var isUserReported: Bool
        var isReviewInappropriate: Bool
        var permissionMsg: String

        enum CodingKeys: String, CodingKey {
            case userID = "userId"
            case email = "email"
            case universityID = "universityId"
            case firstMajorID = "firstMajorId"
            case firstMajorName = "firstMajorName"
            case secondMajorID = "secondMajorId"
            case secondMajorName = "secondMajorName"
            case isReviewed = "isReviewed"
            case isEmailVerified = "isEmailVerified"
            case isUserReported = "isUserReported"
            case isReviewInappropriate = "isReviewInappropriate"
            case permissionMsg = "message"
        }
    }
}
