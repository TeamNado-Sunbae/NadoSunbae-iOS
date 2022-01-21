//
//  NotificationDataModel.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/01/20.
//

import Foundation

struct NotificationDataModel: Codable {
    var notificationList: [NotificationList] = []

    enum CodingKeys: String, CodingKey {
        case notificationList = "notificationList"
    }
}

// MARK: - NotificationList
struct NotificationList: Codable {
    var notificationID: Int = 0
    var sender: Sender = Sender()
    var postID: Int = 0
    var notificationType: Int = 0
    var content: String = ""
    var isRead: Bool = false
    var isDeleted: Bool = false
    var createdAt: String = ""
    var isQuestionToPerson: Bool = false

    enum CodingKeys: String, CodingKey {
        case notificationID = "notificationId"
        case sender = "sender"
        case postID = "postId"
        case notificationType = "notificationType"
        case content = "content"
        case isRead = "isRead"
        case isDeleted = "isDeleted"
        case createdAt = "createdAt"
        case isQuestionToPerson = "isQuestionToPerson"
    }
    
    struct Sender: Codable {
        var senderID: Int = 0
        var nickname: String = ""
        var profileImageID: Int = 0

        enum CodingKeys: String, CodingKey {
            case senderID = "senderId"
            case nickname = "nickname"
            case profileImageID = "profileImageId"
        }
    }
}

enum NotiType: String {
    
    /// 작성하신 질문글
    case writtenQuestion = "작성하신 질문글"
    
    /// 작성하신 정보글
    case writtenInfo = "작성하신 정보글"
    
    /// 답글을 작성하신 질문글
    case answerQuestion = "답글을 작성하신 질문글"
    
    /// 답글을 작성하신 정보글
    case answerInfo = "답글을 작성하신 정보글"
    
    /// 알림을 켜둔 질문글
    case notiQuestion = "알림을 켜둔 질문글"
    
    /// 알림을 켜둔 정보글
    case notiInfo = "알림을 켜둔 정보글"
    
    /// 마이페이지에 온 1:1 질문
    case mypageQuestion = "마이페이지"
}
