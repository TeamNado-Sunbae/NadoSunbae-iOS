//
//  ClassroomService.swift
//  NadoSunbae-iOS
//
//  Created by hwangJi on 2022/01/19.
//

import Foundation
import Moya

enum ClassroomService {
    case getQuestionDetail(postID: Int)
    case getInfoDetail(postID: Int)
    case getGroupQuestionOrInfoList(majorID: Int, postTypeID: Int, sort: ListSortType)
    case postComment(postID: Int, comment: String)
    case getMajorUserList(majorID: Int)
    case postClassroomContent(majorID: Int, answerID: Int?, postTypeID: Int, title: String, content: String)
    case postLike(postID: Int, postTypeID: Int)
    case postTitleEdit(postID: Int, title: String, content: String)
}

extension ClassroomService: TargetType {
    var baseURL: URL {
        return URL(string: APIConstants.baseURL)!
    }
    
    var path: String {
        switch self {
            
        case .getQuestionDetail(let postID):
            return "/classroom-post/question/\(postID)"
        case .getInfoDetail(let postID):
            return "/classroom-post/information/\(postID)"
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
        case .postTitleEdit(let postID, _, _):
            return "/classroom-post/\(postID)"
        }
    }
    
    var method: Moya.Method {
        switch self {
            
        case .getQuestionDetail, .getInfoDetail, .getGroupQuestionOrInfoList, .getMajorUserList:
            return .get
        case .postComment, .postClassroomContent, .postLike:
            return .post
        case .postTitleEdit:
            return .put
        }
    }
    
    var task: Task {
        switch self {
            
        case .getQuestionDetail, .getInfoDetail:
            return .requestPlain
        case .getGroupQuestionOrInfoList(_, _, let sort):
            let body = ["sort": sort]
            return .requestParameters(parameters: body, encoding: URLEncoding.queryString)
        case .postComment(let postID, let comment):
            let body: [String: Any] = [
                "postId": postID,
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
        case .postLike(let postID, let postTypeID):
            let body: [String: Any] = [
                "postId": postID,
                "postTypeId": postTypeID
            ]
            return .requestParameters(parameters: body, encoding: JSONEncoding.prettyPrinted)
            
        case .postTitleEdit(_, let title, let content):
            let body = [
                "title": title,
                "content": content
            ]
            return .requestParameters(parameters: body, encoding: JSONEncoding.prettyPrinted)
        }
    }
    
    var headers: [String: String]? {
        let accessToken: String = UserDefaults.standard.string(forKey: UserDefaults.Keys.AccessToken) ?? ""
        return ["accesstoken": accessToken]
    }
}
