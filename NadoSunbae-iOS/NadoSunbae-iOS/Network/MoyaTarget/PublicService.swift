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
    case requestReport(reportedTargetID: Int, reportedTargetTypeID: Int, reason: String)
    case getAppLink
}

extension PublicService: TargetType {
    
    var baseURL: URL {
        return URL(string: APIConstants.baseURL)!
    }
    
    var path: String {
        switch self {
        case .getMajorList(let univID, _):
            return "/major/university/\(univID)"
        case .requestBlockUnBlockUser:
            return "/block"
        case .requestReport:
            return "/report"
        case .getAppLink:
            return "/app/link"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getMajorList, .getAppLink:
            return .get
        case .requestBlockUnBlockUser, .requestReport:
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
        case .requestReport(let reportedTargetID, let reportedTargetTypeID, let reason):
            let body: [String: Any] = [
                "reportedTargetId": reportedTargetID,
                "reportedTargetTypeId": reportedTargetTypeID,
                "reason": reason
            ]
            return .requestParameters(parameters: body, encoding: JSONEncoding.prettyPrinted)
        case .getAppLink:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .requestBlockUnBlockUser, .requestReport:
            let accessToken = UserToken.shared.accessToken ?? ""
            return ["accessToken": accessToken]
        default:
            return ["Content-Type": "application/json"]
        }
    }
}
