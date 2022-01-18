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
}

extension MypageService: TargetType {
    var baseURL: URL {
        return URL(string: APIConstants.baseURL)!
    }
    
    var path: String {
        switch self {
        case .getUserInfo(let userID, _):
            return "/user/mypage/\(userID)/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getUserInfo:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getUserInfo(let userID, _):
            return .requestParameters(parameters: ["userId": userID], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getUserInfo(_, let accessToken):
            return ["accessToken": accessToken]
        }
    }
}
