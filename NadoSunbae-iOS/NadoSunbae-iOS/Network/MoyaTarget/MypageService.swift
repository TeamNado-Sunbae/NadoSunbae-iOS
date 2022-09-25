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
    case getMypageMyPostList(postType: MypageMyPostType)
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
        case .getMypageMyPostList:
            return "/user/mypage/classroom-post/list"
        case .getMypageMyAnswerList(let postType):
            switch postType {
            case .question:
                return "/user/mypage/comment/list/\(3)"
            case .information:
                return "/user/mypage/comment/list/\(2)"
            }
        case .getMypageMyReviewList(let userID):
            return "/user/\(userID)/review"
        case .getMypageMyLikeList:
            return "/user/mypage/like/list/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getUserInfo, .getUserPersonalQuestionList, .getMypageMyPostList, .getMypageMyAnswerList, .getMypageMyReviewList, .getMypageMyLikeList:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getUserPersonalQuestionList(_, let sort):
            return .requestParameters(parameters: ["sort": sort.rawValue], encoding: URLEncoding.queryString)
        case .getMypageMyPostList(let postType):
            return .requestParameters(parameters: ["type": postType.rawValue], encoding: URLEncoding.queryString)
        case .getMypageMyAnswerList, .getMypageMyReviewList, .getUserInfo:
            return .requestPlain
        case .getMypageMyLikeList(let postType):
            return .requestParameters(parameters: ["type": postType.rawValue], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        let accessToken = UserToken.shared.accessToken ?? ""
        return ["accessToken": accessToken]
    }
}
