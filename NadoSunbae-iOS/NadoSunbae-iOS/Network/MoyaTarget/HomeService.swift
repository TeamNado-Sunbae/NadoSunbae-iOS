//
//  HomeService.swift
//  NadoSunbae
//
//  Created by madilyn on 2022/09/20.
//

import Foundation
import Moya

enum HomeService {
    case getBannerList
    case getAllReviewList
}

extension HomeService: TargetType {
    var baseURL: URL {
        return URL(string: APIConstants.baseURL)!
    }
    
    var path: String {
        switch self {
        case .getBannerList:
            return "/app/banner"
        case .getAllReviewList:
            return "/review/university/\(UserDefaults.standard.integer(forKey: UserDefaults.Keys.univID))"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getBannerList, .getAllReviewList:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getBannerList:
            return .requestParameters(parameters: ["type" : "iOS"], encoding: URLEncoding.queryString)
        case .getAllReviewList:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getAllReviewList:
            let accessToken = UserToken.shared.accessToken ?? ""
            return ["accessToken": accessToken]
        default:
            return ["Content-type": "application/json"]
        }
    }
}
