//
//  MypageService.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/01/19.
//

import Foundation
import Moya

enum MypageService {
    case getUserInfo(userID: Int, accessToken: String)
    case getUserPersonalQuestionList(userID: Int, accessToken: String, sort: ListSortType)
}

extension MypageService: TargetType {
    var baseURL: URL {
        return URL(string: APIConstants.baseURL)!
    }
    
    var path: String {
        switch self {
        case .getUserInfo(let userID, _):
            return "/user/mypage/\(userID)"
        case .getUserPersonalQuestionList(let userID, _, _):
            return "/user/mypage/\(userID)/classroom-post/list"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getUserInfo, .getUserPersonalQuestionList:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getUserInfo(let userID, _):
            return .requestParameters(parameters: ["userId": userID], encoding: URLEncoding.queryString)
        case .getUserPersonalQuestionList(_, _, let sort):
            return .requestParameters(parameters: ["sort": sort.rawValue], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getUserInfo(_, let accessToken):
            return ["accessToken": accessToken]
        case .getUserPersonalQuestionList(_, let accessToken, _):
            return ["accessToken": accessToken]
        }
    }
}
