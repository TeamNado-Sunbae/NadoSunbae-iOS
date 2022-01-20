//
//  DeleteNotificationDataModel.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/01/20.
//

import Foundation

struct DeleteNotificationDataModel: Codable {
    var notificationID: Int
    var isDeleted: Bool

    enum CodingKeys: String, CodingKey {
        case notificationID = "notificationId"
        case isDeleted = "isDeleted"
    }
}
