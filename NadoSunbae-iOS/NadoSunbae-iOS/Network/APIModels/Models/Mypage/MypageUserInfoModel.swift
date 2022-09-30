//
//  MypageUserInfoModel.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/01/18.
//

import Foundation

struct MypageUserInfoModel: Codable, Equatable {
    var userID: Int = 0
    var isOnQuestion: Bool = false
    var profileImageID: Int = 1
    var nickname: String = ""
    var responseRate: Int? = 0
    var bio: String? = ""
    var firstMajorName: String = ""
    var firstMajorStart: String = ""
    var secondMajorName: String = ""
    var secondMajorStart: String = ""
    var count: Int = 0

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case isOnQuestion = "isOnQuestion"
        case profileImageID = "profileImageId"
        case nickname = "nickname"
        case responseRate = "responseRate"
        case bio = "bio"
        case firstMajorName = "firstMajorName"
        case firstMajorStart = "firstMajorStart"
        case secondMajorName = "secondMajorName"
        case secondMajorStart = "secondMajorStart"
        case count = "count"
    }
}
