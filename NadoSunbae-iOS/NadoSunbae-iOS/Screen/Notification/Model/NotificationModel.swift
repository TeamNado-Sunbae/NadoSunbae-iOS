//
//  NotificationModel.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/01/17.
//

import Foundation

enum NotiType: Codable {
    
    /// 작성하신 질문글
    case writtenQuestion
    
    /// 작성하신 정보글
    case writtenInfo
    
    /// 답글을 작성하신 질문글
    case answerQuestion
    
    /// 답글을 작성하신 정보글
    case answerInfo
    
    /// 알림을 켜둔 질문글
    case notiQuestion
    
    /// 알림을 켜둔 정보글
    case notiInfo
    
    /// 마이페이지에 온 1:1 질문
    case mypageQuestion
}

struct NotificationModel: Codable {
    var senderNickName: String
    var notiType: NotiType
    var time: String
    var isRead: Bool
    var title: String
    var content: String
}
