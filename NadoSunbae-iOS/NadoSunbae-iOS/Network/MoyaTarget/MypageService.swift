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
    case getUserPostList(postType: MypageMyPostType)
    case getMypageMyAnswerList(postType: MypageMyPostType)
    case getMypageMyReviewList(userID: Int)
    case getMypageMyLikeList(postType: MypageLikePostType)
}

extension MypageService: TargetType {
    var baseURL: URL {
        return URL(string: APIConstants.baseURL)!
    }
    
    var path: String {
        switch self {
        case .getUserInfo(let userID):
            return "/user/\(userID)"
        case .getUserPersonalQuestionList(let userID, _):
            return "/user/\(userID)/post/question"
        case .getUserPostList:
            return "/user/post"
        case .getMypageMyAnswerList:
            return "/user/comment"
        case .getMypageMyReviewList(let userID):
            return "/user/\(userID)/review"
        case .getMypageMyLikeList:
            return "/user/like"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getUserInfo, .getUserPersonalQuestionList, .getUserPostList, .getMypageMyAnswerList, .getMypageMyReviewList, .getMypageMyLikeList:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getUserPersonalQuestionList(_, let sort):
            return .requestParameters(parameters: ["sort": sort.rawValue], encoding: URLEncoding.queryString)
        case .getUserPostList(let postType), .getMypageMyAnswerList(let postType):
            return .requestParameters(parameters: ["filter": postType.rawValue], encoding: URLEncoding.queryString)
        case .getMypageMyReviewList, .getUserInfo:
            return .requestPlain
        case .getMypageMyLikeList(let postType):
            return .requestParameters(parameters: ["filter": postType.rawValue], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        let accessToken = UserToken.shared.accessToken ?? ""
        return ["accessToken": accessToken]
    }
}
