//
//  ClassroomQuestionDetailData.swift
//  NadoSunbae-iOS
//
//  Created by hwangJi on 2022/01/19.
//

import Foundation

// MARK: - ClassroomQuestionDetailData
struct ClassroomQuestionDetailData: Codable {
    let questionerID, answererID: Int
    let like: ClassroomQuestionLike
    let messageList: [ClassroomMessageList]

    enum CodingKeys: String, CodingKey {
        case questionerID = "questionerId"
        case answererID = "answererId"
        case like, messageList
    }
}

// MARK: - ClassroomQuestionLike
struct ClassroomQuestionLike: Codable {
    let isLiked: Bool
    let likeCount: Int
}

// MARK: - ClassroomQuestionWriter
struct ClassroomMessageList: Codable {
    let messageID: Int
    let title, content, createdAt: String
    let isDeleted: Bool
    let writer: ClassroomQuestionWriter

    enum CodingKeys: String, CodingKey {
        case messageID = "messageId"
        case title, content, createdAt, isDeleted, writer
    }
}

// MARK: - ClassroomQuestionWriter
struct ClassroomQuestionWriter: Codable {
    let writerID, profileImageID: Int
    let isQuestioner: Bool
    let nickname, firstMajorName, firstMajorStart, secondMajorName: String
    let secondMajorStart: String

    enum CodingKeys: String, CodingKey {
        case writerID = "writerId"
        case profileImageID = "profileImageId"
        case isQuestioner, nickname, firstMajorName, firstMajorStart, secondMajorName, secondMajorStart
    }
}
