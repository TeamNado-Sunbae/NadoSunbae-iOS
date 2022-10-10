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
    var userID: Int
    var profileImageID: Int
    var isOnQuestion: Bool
    var nickname: String
    var isFirstMajor: Bool
    var majorStart: String
    var rate: Int

    enum CodingKeys: String, CodingKey {
        case userID = "id"
        case profileImageID = "profileImageId"
        case isOnQuestion = "isOnQuestion"
        case nickname = "nickname"
        case isFirstMajor = "isFirstMajor"
        case majorStart = "majorStart"
        case rate = "rate"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        userID = (try? values.decode(Int.self, forKey: .userID)) ?? -1
        profileImageID = (try? values.decode(Int.self, forKey: .profileImageID)) ?? -1
        isOnQuestion = (try? values.decode(Bool.self, forKey: .isOnQuestion)) ?? false
        nickname = (try? values.decode(String.self, forKey: .nickname)) ?? ""
        isFirstMajor = (try? values.decode(Bool.self, forKey: .isFirstMajor)) ?? false
        majorStart = (try? values.decode(String.self, forKey: .majorStart)) ?? ""
        rate = (try? values.decode(Int.self, forKey: .rate)) ?? -1
    }
    
    init() {
        // 더보기라는 특수한 상황 -> userID를 -2로 할당한다.
        userID = -2
        profileImageID = 0
        isOnQuestion = true
        nickname = ""
        isFirstMajor = false
        majorStart = ""
        rate = 0
    }
}
