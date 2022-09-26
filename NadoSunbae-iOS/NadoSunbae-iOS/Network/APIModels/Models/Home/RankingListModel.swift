//
//  RankingListModel.swift
//  NadoSunbae
//
//  Created by EUNJU on 2022/09/19.
//

import Foundation

// MARK: - RankingListModel
struct RankingListModel: Codable {
    let id: Int
    let profileImageID: Int
    let nickname: String
    let firstMajorName: String
    let firstMajorStart: String
    let secondMajorName: String
    let secondMajorStart: String
    let rate: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case profileImageID = "profileImageId"
        case nickname, firstMajorName, firstMajorStart, secondMajorName, secondMajorStart, rate
    }
}
