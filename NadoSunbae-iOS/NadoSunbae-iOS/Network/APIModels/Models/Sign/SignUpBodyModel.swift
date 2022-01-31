//
//  SignUpBodyModel.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/01/30.
//

import Foundation

struct SignUpBodyModel: Codable {
    var email: String = ""
    var nickName: String = ""
    var PW: String = ""
    var universityID: Int = 0
    var firstMajorID: Int = 0
    var firstMajorStart: String = ""
    var secondMajorID: Int = 0
    var secondMajorStart: String = ""
    
    enum CodingKeys: String, CodingKey {
        case email = "email"
        case nickName = "nickname"
        case PW = "password"
        case universityID = "universityId"
        case firstMajorID = "firstMajorId"
        case firstMajorStart = "firstMajorStart"
        case secondMajorID = "secondMajorId"
        case secondMajorStart = "secondMajorStart"
    }
}
