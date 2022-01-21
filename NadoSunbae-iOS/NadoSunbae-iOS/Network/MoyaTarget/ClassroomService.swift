//
//  ClassroomService.swift
//  NadoSunbae-iOS
//
//  Created by hwangJi on 2022/01/19.
//

import Foundation
import Moya

enum ClassroomService {
    case getQuestionDetail(chatPostID: Int)
    case getGroupQuestionOrInfoList(majorID: Int, postTypeID: Int, sort: ListSortType)
    case postComment(chatPostID: Int, comment: String)
    case getMajorUserList(majorID: Int)
}

extension ClassroomService: TargetType {
    var baseURL: URL {
        return URL(string: APIConstants.baseURL)!
    }
    
    var path: String {
        switch self {
            
        case .getQuestionDetail(let chatPostID):
            return "/classroom-post/question/\(chatPostID)"
        case .getGroupQuestionOrInfoList(let majorID, let postTypeID, _):
            return "/classroom-post/\(postTypeID)/major/\(majorID)/list"
        case .postComment:
            return "/comment"
        case .getMajorUserList(let majorID):
            return "/user/mypage/list/major/\(majorID)"
        }
    }
    
    var method: Moya.Method {
        switch self {
            
        case .getQuestionDetail, .getGroupQuestionOrInfoList, .getMajorUserList:
            return .get
        case .postComment:
            return .post
        }
    }
    
    var task: Task {
        switch self {
            
        case .getQuestionDetail:
            return .requestPlain
        case .getGroupQuestionOrInfoList(_, _, let sort):
            let body = ["sort": sort]
            return .requestParameters(parameters: body, encoding: URLEncoding.queryString)
        case .postComment(let chatPostID, let comment):
            let body: [String: Any] = [
                "postId": chatPostID,
                "content": comment
            ]
            return .requestParameters(parameters: body, encoding: JSONEncoding.prettyPrinted)
        case .getMajorUserList(let majorID):
            let body = ["majorId": majorID]
            return .requestParameters(parameters: body, encoding: JSONEncoding.prettyPrinted)
        }
    }
    
    var headers: [String: String]? {
        let accessToken: String = UserDefaults.standard.string(forKey: UserDefaults.Keys.AccessToken) ?? ""
        return ["accesstoken": accessToken]
    }
}
