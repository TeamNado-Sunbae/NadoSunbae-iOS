//
//  ReviewHomePageData.swift
//  NadoSunbae-iOS
//
//  Created by EUNJU on 2022/01/22.
//

import Foundation

// MARK: - DataClass
struct ReviewHomePageData: Codable {
    let majorName: String
    let homepage: String
    let subjectTable: String

    enum CodingKeys: String, CodingKey {
        case majorName = "majorName"
        case homepage = "homepage"
        case subjectTable = "subjectTable"
    }
}

