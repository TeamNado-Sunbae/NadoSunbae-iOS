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

    enum CodingKeys: String, CodingKey {
        case user = "user"
        case accesstoken = "accesstoken"
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
        }
    }
}
