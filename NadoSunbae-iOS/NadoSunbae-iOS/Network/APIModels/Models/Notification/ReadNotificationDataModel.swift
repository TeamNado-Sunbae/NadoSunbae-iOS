//
//  ReadNotificationDataModel.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/01/20.
//

import Foundation

struct ReadNotificationDataModel: Codable {
    var notificationID: Int
    var receiverID: Int
    var isRead: Bool
    var createdAt: String
    var updatedAt: String
    var isDeleted: Bool

    enum CodingKeys: String, CodingKey {
        case notificationID = "notificationId"
        case receiverID = "receiverId"
        case isRead = "isRead"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
        case isDeleted = "isDeleted"
    }
}
