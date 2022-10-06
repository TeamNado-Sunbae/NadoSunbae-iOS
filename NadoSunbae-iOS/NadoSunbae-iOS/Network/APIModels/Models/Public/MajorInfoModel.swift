//
//  MajorInfoModel.swift
//  NadoSunbae-iOS
//
//  Created by EUNJU on 2022/01/19.
//

import Foundation

// MARK: - MajorInfoModel
struct MajorInfoModel: Codable, Hashable {
    let majorID: Int
    let majorName: String

    enum CodingKeys: String, CodingKey {
        case majorID = "majorId"
        case majorName
    }
}
