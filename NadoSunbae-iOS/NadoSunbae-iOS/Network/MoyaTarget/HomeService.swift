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
}

extension HomeService: TargetType {
    var baseURL: URL {
        return URL(string: APIConstants.baseURL)!
    }
    
    var path: String {
        switch self {
        case .getBannerList:
            return "/app/banner"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getBannerList:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getBannerList:
            return .requestParameters(parameters: ["type" : "iOS"], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            return ["Content-type": "application/json"]
        }
    }
}
