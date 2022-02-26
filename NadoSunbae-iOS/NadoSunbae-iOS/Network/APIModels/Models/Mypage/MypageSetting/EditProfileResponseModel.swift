//
//  EditProfileResponseModel.swift
//  NadoSunbae-iOS
//
//  Created by madilyn on 2022/02/26.
//

import Foundation
struct EditProfileResponseModel: Codable {
    var nickname: String
    var firstMajorID: Int
    var firstMajorStart: String
    var secondMajorID: Int
    var secondMajorStart: String
    var isOnQuestion: Bool
    var updatedAt: String

    enum CodingKeys: String, CodingKey {
        case firstMajorID = "firstMajorId"
        case secondMajorID = "secondMajorId"
        case nickname, firstMajorStart, secondMajorStart, isOnQuestion, updatedAt
    }
}
