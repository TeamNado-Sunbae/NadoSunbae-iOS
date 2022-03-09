//
//  NotificationService.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/01/19.
//

import Foundation
import Moya

enum NotificationService {
    case getNotiList
    case readNoti(notiID: Int)
    case deleteNoti(notiID: Int)
}

extension NotificationService: TargetType {
    var userID: Int {
        return UserDefaults.standard.integer(forKey: UserDefaults.Keys.UserID)
    }
    
    var baseURL: URL {
        return URL(string: APIConstants.baseURL)!
    }
    
    var path: String {
        switch self {
        case .getNotiList:
            return "/notification/list/\(userID)"
        case .readNoti(let notiID):
            return "/notification/read/\(notiID)"
        case .deleteNoti(let notiID):
            return "/notification/\(notiID)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getNotiList:
            return .get
        case .readNoti:
            return .put
        case .deleteNoti:
            return .delete
        }
    }
    
    var task: Task {
        switch self {
        case .getNotiList:
            return .requestParameters(parameters: ["receiverId": userID], encoding: URLEncoding.queryString)
        case .readNoti(let notiID), .deleteNoti(let notiID):
            return .requestParameters(parameters: ["notification": notiID], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        let accessToken = UserToken.shared.accessToken ?? ""
        return ["accessToken": accessToken]
    }
}
