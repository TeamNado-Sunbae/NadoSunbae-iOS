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
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        questionerID = (try? values.decode(Int.self, forKey: .questionerID)) ?? -1
        answererID = (try? values.decode(Int.self, forKey: .answererID)) ?? 0
        like = (try? values.decode(ClassroomQuestionLike.self, forKey: .like)) ?? ClassroomQuestionLike(isLiked: true, likeCount: 1)
        messageList = (try? values.decode([ClassroomMessageList].self, forKey: .messageList)) ?? []
    }
}

// MARK: - ClassroomQuestionLike
struct ClassroomQuestionLike: Codable {
    let isLiked: Bool
    let likeCount: Int
}

// MARK: - ClassroomMessageList
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

func convertToMajorInfoString(_ firstMajorName: String, _ firstMajorStart: String, _ secondMajorName: String, _ secondMajorStart: String) -> String {
    if secondMajorName == "미진입" {
        return firstMajorName + " " + firstMajorStart + " " + "|" + " " + secondMajorName
    } else {
        return firstMajorName + " " + firstMajorStart + " " + "|" + " " + secondMajorName + " " + secondMajorStart
    }
}
