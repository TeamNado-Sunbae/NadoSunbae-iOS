//
//  MypageUserInfoModel.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/01/18.
//

import Foundation

struct MypageUserInfoModel: Codable {
    let userID, profileImageID: Int
    let nickname, firstMajorName, firstMajorStart, secondMajorName: String
    let secondMajorStart: String
    let isOnQuestion: Bool

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case profileImageID = "profileImageId"
        case nickname, firstMajorName, firstMajorStart, secondMajorName, secondMajorStart, isOnQuestion
    }
}
