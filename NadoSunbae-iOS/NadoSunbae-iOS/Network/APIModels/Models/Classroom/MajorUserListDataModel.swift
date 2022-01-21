//
//  MajorUserListDataModel.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/01/21.
//

import Foundation

struct MajorUserListDataModel: Codable {
    var onQuestionUserList: [QuestionUser] = []
    var offQuestionUserList: [QuestionUser] = []

    enum CodingKeys: String, CodingKey {
        case onQuestionUserList = "onQuestionUserList"
        case offQuestionUserList = "offQuestionUserList"
    }
}

struct QuestionUser: Codable {
    var userID: Int = 0
    var profileImageID: Int = 0
    var isOnQuestion: Bool = true
    var nickname: String = ""
    var isFirstMajor: Bool = true
    var majorStart: String = ""

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case profileImageID = "profileImageId"
        case isOnQuestion = "isOnQuestion"
        case nickname = "nickname"
        case isFirstMajor = "isFirstMajor"
        case majorStart = "majorStart"
    }
}
