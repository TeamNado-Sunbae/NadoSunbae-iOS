//
//  NotificationDataModel.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/01/20.
//

import Foundation

// MARK: - GetNotiListResponseData
struct GetNotiListResponseData: Codable {
    var notificationList: [NotificationList]

    enum CodingKeys: String, CodingKey {
        case notificationList = "notificationList"
    }
}

// MARK: - NotificationList
struct NotificationList: Codable {
    var notificationID: Int
    var sender: Sender
    var isRead: Bool
    var content: String
    var createdAt: String
    var postID: Int
    var commentID: Int
    var notificationTypeID: Int

    enum CodingKeys: String, CodingKey {
        case notificationID = "notificationId"
        case sender = "sender"
        case isRead = "isRead"
        case content = "content"
        case createdAt = "createdAt"
        case postID = "postId"
        case commentID = "commentId"
        case notificationTypeID = "notificationTypeId"
    }
    
    // MARK: - Sender
    struct Sender: Codable {
        var senderID: Int
        var nickname: String
        var profileImageID: Int

        enum CodingKeys: String, CodingKey {
            case senderID = "senderId"
            case nickname = "nickname"
            case profileImageID = "profileImageId"
        }
    }
}

enum NotiType: String {
    
    /// 작성하신 질문글(legacy)
    case writtenQuestion = "작성하신 질문글"
    
    /// 작성하신 정보글(legacy)
    case writtenInfo = "작성하신 정보글"
    
    /// 답글을 작성하신 질문글(legacy)
    case answerQuestion = "답글을 작성하신 질문글"
    
    /// 답글을 작성하신 정보글(legacy)
    case answerInfo = "답글을 작성하신 정보글"
    
    /// 알림을 켜둔 질문글(legacy)
    case notiQuestion = "알림을 켜둔 질문글"
    
    /// 알림을 켜둔 정보글(legacy)
    case notiInfo = "알림을 켜둔 정보글"
    
    /// 마이페이지에 온 1:1 질문
    case questionToPerson = "마이페이지"
    
    /// 커뮤니티
    case community = "커뮤니티"
    
    /// 에러 처리를 위한 case
    case none = "none type"
}
