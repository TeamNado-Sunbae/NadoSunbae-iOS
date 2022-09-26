//
//  HomeRankingResponseModel.swift
//  NadoSunbae
//
//  Created by madilyn on 2022/08/14.
//

import Foundation

struct HomeRankingResponseModel: Codable {
    let userList: [UserList]

    enum CodingKeys: String, CodingKey {
        case userList = "userList"
    }
    
    // MARK: - UserList
    struct UserList: Codable {
        let id: Int
        let profileImageID: Int
        let nickname: String
        let firstMajorName: String
        let firstMajorStart: String
        let secondMajorName: String
        let secondMajorStart: String
        let rate: Int?

        enum CodingKeys: String, CodingKey {
            case id = "id"
            case profileImageID = "profileImageId"
            case nickname = "nickname"
            case firstMajorName = "firstMajorName"
            case firstMajorStart = "firstMajorStart"
            case secondMajorName = "secondMajorName"
            case secondMajorStart = "secondMajorStart"
            case rate = "rate"
        }
    }
}
