//
//  SignUpDataModel.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/01/30.
//

import Foundation

struct SignUpDataModel: Codable {
    var user: User

    enum CodingKeys: String, CodingKey {
        case user = "user"
    }
    
    struct User: Codable {
        var userID: Int
        var createdAt: String

        enum CodingKeys: String, CodingKey {
            case userID = "userId"
            case createdAt = "createdAt"
        }
    }
}
