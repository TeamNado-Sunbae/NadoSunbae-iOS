//
//  ReviewMainPostListService.swift
//  NadoSunbae-iOS
//
//  Created by EUNJU on 2022/01/20.
//

import Foundation
import Moya

enum ReviewMainPostListService {
    case getReviewMainPostList(majorID: Int, writerFilter: Int, tagFilter:[Int])
}

extension ReviewMainPostListService: TargetType {
    
    var baseURL: URL {
        return URL(string: APIConstants.baseURL)!
    }
    
    var path: String {
        switch self {
            
        case .getReviewMainPostList:
            return "/review-post/list?sort="
        }
    }
    
    var method: Moya.Method {
        switch self {
            
        case .getReviewMainPostList:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .getReviewMainPostList(let majorID, let writerFilter, let tagFilter):
            
            let body: [String : Any] = [
                "majorId" : majorID,
                "writerFilter" : writerFilter,
                "tagFilter" : tagFilter
            ]
            
            return .requestParameters(parameters: body, encoding: URLEncoding.queryString)
        }
    }
    
    
    var headers: [String : String]? {
        let accessToken: String = UserDefaults.standard.string(forKey: UserDefaults.Keys.AccessToken) ?? ""
        print(accessToken)
        
        switch self {
            
        case .getReviewMainPostList:
            return ["accesstoken" : accessToken]
        }
    }
}

