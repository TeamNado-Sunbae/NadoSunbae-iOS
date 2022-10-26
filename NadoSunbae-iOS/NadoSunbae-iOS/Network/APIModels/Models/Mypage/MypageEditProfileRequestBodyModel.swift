//
//  MypageEditProfileBodyModel.swift
//  NadoSunbae
//
//  Created by madilyn on 2022/10/26.
//

import Foundation

struct MypageEditProfileRequestBodyModel: Codable, Equatable {
    var profileImageID: Int = 1
    var nickname: String = ""
    var bio: String = ""
    var isOnQuestion: Bool = false
    var firstMajorName: String? = ""
    var firstMajorID: Int = 0
    var firstMajorStart: String = ""
    var secondMajorName: String? = ""
    var secondMajorID: Int = 0
    var secondMajorStart: String = ""

    enum CodingKeys: String, CodingKey {
        case profileImageID = "profileImageId"
        case nickname, bio, isOnQuestion
        case firstMajorID = "firstMajorId"
        case firstMajorStart
        case secondMajorID = "secondMajorId"
        case secondMajorStart
    }
}
