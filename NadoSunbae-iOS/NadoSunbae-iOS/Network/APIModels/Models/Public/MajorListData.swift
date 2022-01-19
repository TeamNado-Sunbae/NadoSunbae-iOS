//
//  MajorListData.swift
//  NadoSunbae-iOS
//
//  Created by EUNJU on 2022/01/19.
//

import Foundation

// MARK: - MajorListData
struct MajorListData: Codable {
    let majorID: Int
    let majorName: String
    let isFirstMajor, isSecondMajor: Bool

    enum CodingKeys: String, CodingKey {
        case majorID = "majorId"
        case majorName, isFirstMajor, isSecondMajor
    }
}
