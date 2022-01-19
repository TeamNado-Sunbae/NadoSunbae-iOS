//
//  MypageService.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/01/19.
//

import Foundation
import Moya

enum MypageService {
    case getUserInfo(userID: Int)
    case getUserPersonalQuestionList(userID: Int, sort: ListSortType)
}

extension MypageService: TargetType {
    var baseURL: URL {
        return URL(string: APIConstants.baseURL)!
    }
    
    var path: String {
        switch self {
        case .getUserInfo(let userID):
            return "/user/mypage/\(userID)"
        case .getUserPersonalQuestionList(let userID, _):
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
        case .getUserInfo(let userID):
            return .requestParameters(parameters: ["userId": userID], encoding: URLEncoding.queryString)
        case .getUserPersonalQuestionList(_, let sort):
            return .requestParameters(parameters: ["sort": sort.rawValue], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        let accessToken = UserDefaults.standard.value(forKey: UserDefaults.Keys.AccessToken) as! String
        return ["accessToken": accessToken]
    }
}
