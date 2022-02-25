//
//  EditProfileRequestModel.swift
//  NadoSunbae-iOS
//
//  Created by madilyn on 2022/02/26.
//

import Foundation

struct EditProfileRequestModel: Codable {
    var nickName: String = ""
    var firstMajorID: Int = 1
    var firstMajorStart: String = ""
    var secondMajorID: Int = 1
    var secondMajorStart: String = ""
    var isOnQuestion: Bool = false
}
