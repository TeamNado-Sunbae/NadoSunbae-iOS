//
//  PublicService.swift
//  NadoSunbae-iOS
//
//  Created by EUNJU on 2022/01/19.
//

import Foundation
import Moya

enum PublicService {
    case getMajorList(univID: Int, filter: String)
    case requestBlockUnBlockUser(blockUserID: Int)
}

extension PublicService: TargetType {
    
    var baseURL: URL {
        return URL(string: APIConstants.baseURL)!
    }
    
    var path: String {
        switch self {
        case .getMajorList(let univID, _):
            return "/major/list/\(univID)"
        case .requestBlockUnBlockUser:
            return "/block"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getMajorList:
            return .get
        case .requestBlockUnBlockUser:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .getMajorList(_, let filter):
            let body = ["filter": filter]
            return .requestParameters(parameters: body, encoding: URLEncoding.queryString)
        case .requestBlockUnBlockUser(let blockUserID):
            return .requestParameters(parameters: ["blockedUserId": blockUserID], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .requestBlockUnBlockUser:
            let accessToken = UserDefaults.standard.string(forKey: UserDefaults.Keys.AccessToken)!
            return ["accessToken": accessToken]
        default:
            return ["Content-Type": "application/json"]
        }
    }
}
