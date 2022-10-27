//
//  PublicService.swift
//  NadoSunbae-iOS
//
//  Created by EUNJU on 2022/01/19.
//

import Foundation
import Moya

enum PublicService {
    case getMajorList(univID: Int, filter: String, userID: Int)
    case registerFavoriteMajor(majorID: Int)
    case requestBlockUnBlockUser(blockUserID: Int)
    case requestReport(reportedTargetID: Int, postType: ReportPostType, reason: String)
    case getAppLink
    case getPostList(univID: Int, majorID: Int, filter: PostFilterType, sort: String, search: String)
    case getPostDetail(postID: Int)
    case requestWritePost(type: PostFilterType, majorID: Int, answererID: Int, title: String, content: String)
    case editPost(postID: Int, title: String, content: String)
    case editPostComment(commentID: Int, content: String)
    case likePost(postID: Int, postType: RequestLikePostType)
    case deletePost(postID: Int)
}

extension PublicService: TargetType {
    
    var baseURL: URL {
        return URL(string: APIConstants.baseURL)!
    }
    
    var path: String {
        switch self {
        case .getMajorList(let univID, _, _):
            return "/major/university/\(univID)"
        case .registerFavoriteMajor:
            return "/favorites"
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
        case .likePost:
            return "/like"
        case .deletePost(let postID):
            return "/post/\(postID)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getMajorList, .getAppLink, .getPostList, .getPostDetail:
            return .get
        case .requestBlockUnBlockUser, .requestReport, .requestWritePost, .likePost, .registerFavoriteMajor:
            return .post
        case .editPost, .editPostComment:
            return .put
        case .deletePost:
            return .delete
        }
    }
    
    var task: Task {
        switch self {
        case .getMajorList(_, let filter, let userID):
            let body: [String: Any] = [
                "filter": filter,
                "userId": userID
            ]
            return .requestParameters(parameters: body, encoding: URLEncoding.queryString)
        case .registerFavoriteMajor(let majorID):
            return .requestParameters(parameters: ["majorId": majorID], encoding: JSONEncoding.default)
        case .requestBlockUnBlockUser(let blockUserID):
            return .requestParameters(parameters: ["blockedUserId": blockUserID], encoding: JSONEncoding.default)
        case .requestReport(let reportedTargetID, let postType, let reason):
            let body: [String: Any] = [
                "targetId": reportedTargetID,
                "type": postType.rawValue,
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
        case .likePost(let postID, let type):
            let body: [String: Any] = [
                "targetId": postID,
                "type": type.rawValue
            ]
            return .requestParameters(parameters: body, encoding: JSONEncoding.prettyPrinted)
        case .deletePost:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .requestBlockUnBlockUser, .requestReport, .getPostList, .requestWritePost, .getPostDetail, .editPost, .editPostComment, .likePost, .deletePost, .registerFavoriteMajor:
            let accessToken = UserToken.shared.accessToken ?? ""
            return ["accessToken": accessToken]
        default:
            return ["Content-Type": "application/json"]
        }
    }
}
