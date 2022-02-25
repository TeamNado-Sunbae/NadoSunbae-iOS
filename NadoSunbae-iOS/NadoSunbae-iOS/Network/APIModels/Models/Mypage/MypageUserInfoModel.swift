//
//  MypageUserInfoModel.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/01/18.
//

import Foundation

struct MypageUserInfoModel: Codable {
    var userID: Int = 0
    var profileImageID: Int = 0
    var nickname: String = ""
    var firstMajorID: Int = 0
    var firstMajorName: String = ""
    var firstMajorStart: String = ""
    var secondMajorID: Int = 0
    var secondMajorName: String = ""
    var secondMajorStart: String = ""
    var isOnQuestion: Bool = true
    var count: Int = 0

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case profileImageID = "profileImageId"
        case nickname = "nickname"
        case firstMajorID = "firstMajorId"
        case firstMajorName = "firstMajorName"
        case firstMajorStart = "firstMajorStart"
        case secondMajorID = "secondMajorId"
        case secondMajorName = "secondMajorName"
        case secondMajorStart = "secondMajorStart"
        case isOnQuestion = "isOnQuestion"
        case count = "count"
    }
}
