//
//  RequestBlockUnblockUserModel.swift
//  NadoSunbae-iOS
//
//  Created by madilyn on 2022/02/28.
//

import Foundation

struct RequestBlockUnblockUserModel: Codable {
    var id, blockUserID, blockedUserID: Int
    var createdAt, updatedAt: String
    var isDeleted: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case blockUserID = "blockUserId"
        case blockedUserID = "blockedUserId"
        case createdAt, updatedAt, isDeleted
    }
}
