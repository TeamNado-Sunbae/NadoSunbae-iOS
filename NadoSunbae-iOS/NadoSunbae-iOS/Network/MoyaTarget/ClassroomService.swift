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
    case getInfoDetail(chatPostID: Int)
    case getGroupQuestionOrInfoList(majorID: Int, postTypeID: Int, sort: ListSortType)
    case postComment(chatPostID: Int, comment: String)
    case getMajorUserList(majorID: Int)
    case postClassroomContent(majorID: Int, answerID: Int?, postTypeID: Int, title: String, content: String)
    case postLike(chatPostID: Int, postTypeID: Int)
}

extension ClassroomService: TargetType {
    var baseURL: URL {
        return URL(string: APIConstants.baseURL)!
    }
    
    var path: String {
        switch self {
            
        case .getQuestionDetail(let chatPostID):
            return "/classroom-post/question/\(chatPostID)"
        case .getInfoDetail(let chatPostID):
            return "/classroom-post/information/\(chatPostID)"
        case .getGroupQuestionOrInfoList(let majorID, let postTypeID, _):
            return "/classroom-post/\(postTypeID)/major/\(majorID)/list"
        case .postComment:
            return "/comment"
        case .getMajorUserList(let majorID):
            return "/user/mypage/list/major/\(majorID)"
        case .postClassroomContent:
            return "/classroom-post"
        case .postLike:
            return "/like"
        }
    }
    
    var method: Moya.Method {
        switch self {
            
        case .getQuestionDetail, .getInfoDetail, .getGroupQuestionOrInfoList, .getMajorUserList:
            return .get
        case .postComment, .postClassroomContent, .postLike:
            return .post
        }
    }
    
    var task: Task {
        switch self {
            
        case .getQuestionDetail, .getInfoDetail:
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
            return .requestParameters(parameters: body, encoding: URLEncoding.queryString)
        case .postClassroomContent(let majorID, let answerID, let postTypeID, let title, let content):
            let body: [String: Any] = [
                "majorId": majorID,
                "answererId": answerID,
                "postTypeId": postTypeID,
                "title": title,
                "content": content
            ]
            return .requestParameters(parameters: body, encoding: JSONEncoding.prettyPrinted)
        case .postLike(let chatPostID, let postTypeID):
            let body: [String: Any] = [
                "postId": chatPostID,
                "postTypeId": postTypeID
            ]
            return .requestParameters(parameters: body, encoding: JSONEncoding.prettyPrinted)
        }
    }
    
    var headers: [String: String]? {
        let accessToken: String = UserDefaults.standard.string(forKey: UserDefaults.Keys.AccessToken) ?? ""
        return ["accesstoken": accessToken]
    }
}
