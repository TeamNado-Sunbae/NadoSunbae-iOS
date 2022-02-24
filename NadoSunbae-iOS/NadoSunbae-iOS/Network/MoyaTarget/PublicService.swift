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
}

extension PublicService: TargetType {
    
    var baseURL: URL {
        return URL(string: APIConstants.baseURL)!
    }
    
    var path: String {
        switch self {
            
        case .getMajorList(let univID, _):
            return "/major/list/\(univID)"
        }
    }
    
    var method: Moya.Method {
        switch self {
            
        case .getMajorList:
            return .get
        }
    }
    
    var task: Task {
        switch self {
            
        case .getMajorList(_, let filter):
            let body = ["filter": filter]
            return .requestParameters(parameters: body, encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
