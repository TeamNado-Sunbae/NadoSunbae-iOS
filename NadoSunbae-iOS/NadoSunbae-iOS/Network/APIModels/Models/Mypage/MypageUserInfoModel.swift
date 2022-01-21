//
//  MypageUserInfoModel.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/01/18.
//

import Foundation

struct MypageUserInfoModel: Codable {
    var userID: Int = 0
    var profileImageID: Int = 1
    var nickname: String = ""
    var firstMajorName: String = ""
    var firstMajorStart: String = ""
    var secondMajorName: String = ""
    var secondMajorStart: String = ""
    var isOnQuestion: Bool = true

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case profileImageID = "profileImageId"
        case nickname, firstMajorName, firstMajorStart, secondMajorName, secondMajorStart, isOnQuestion
    }
}
