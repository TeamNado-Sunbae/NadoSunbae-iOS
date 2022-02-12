//
//  SignUpDataModel.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/01/30.
//

import Foundation

struct SignUpDataModel: Codable {
    let user: User
    let accesstoken: String
    
    struct User: Codable {
        let userID: Int
        let createdAt: String

        enum CodingKeys: String, CodingKey {
            case userID = "userId"
            case createdAt
        }
    }
}
