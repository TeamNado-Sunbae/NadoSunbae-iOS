//
//  GetBlockListResponseModel.swift
//  NadoSunbae-iOS
//
//  Created by madilyn on 2022/02/28.
//

import Foundation

struct GetBlockListResponseModel: Codable {
    var userID, profileImageID: Int
    var nickname: String

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case profileImageID = "profileImageId"
        case nickname
    }
}
