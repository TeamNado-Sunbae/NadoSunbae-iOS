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
    case getPostList(univID: Int, majorID: Int, filter: PostFilterType, sort: String, search: String)
    case getPostDetail(postID: Int)
    case requestWritePost(type: PostFilterType, majorID: Int, answererID: Int, title: String, content: String)
    case editPost(postID: Int, title: String, content: String)
    case editPostComment(commentID: Int, content: String)
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
        case .getPostList(let univID, _, _, _, _):
            return "/post/university/\(univID)"
        case .getPostDetail(let postID):
            return "/post/\(postID)"
        case .requestWritePost:
            return "/post"
        case .editPost(let postID, _, _):
            return "/post/\(postID)"
        case .editPostComment(let commentID, _):
            return "/comment/\(commentID)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getMajorList, .getAppLink, .getPostList, .getPostDetail:
            return .get
        case .requestBlockUnBlockUser, .requestReport, .requestWritePost:
            return .post
        case .editPost, .editPostComment:
            return .put
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
        case .getPostList(_, let majorID, let filter, let sort, let search):
            let query: [String: Any] = [
                "majorId": majorID,
                "filter": filter,
                "sort": sort,
                "search": search
            ]
            return .requestParameters(parameters: query, encoding:  URLEncoding.queryString)
        case .getPostDetail:
            return .requestPlain
        case .requestWritePost(let type, let majorID, let answererID, let title, let content):
            let body: [String: Any] = [
                "type": "\(type)",
                "majorId": majorID,
                "answererId": answererID,
                "title": title,
                "content": content
            ]
            return .requestParameters(parameters: body, encoding: JSONEncoding.prettyPrinted)
        case .editPost(_, let title, let content):
            let body = [
                "title": title,
                "content": content
            ]
            return .requestParameters(parameters: body, encoding: JSONEncoding.prettyPrinted)
        case .editPostComment(_, let content):
            let body = ["content": content]
            return .requestParameters(parameters: body, encoding: JSONEncoding.prettyPrinted)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .requestBlockUnBlockUser, .requestReport, .getPostList, .requestWritePost, .getPostDetail, .editPost, .editPostComment:
            let accessToken = UserToken.shared.accessToken ?? ""
            return ["accessToken": accessToken]
        default:
            return ["Content-Type": "application/json"]
        }
    }
}
