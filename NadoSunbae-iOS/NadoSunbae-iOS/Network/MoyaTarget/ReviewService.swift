//
//  ReviewService.swift
//  NadoSunbae-iOS
//
//  Created by 황지은 on 2022/01/06.
//

import Foundation
import Moya

enum ReviewService {
}

extension ReviewService: TargetType {
    var baseURL: URL {
        return URL(string: APIConstants.baseURL)!
    }
    
    var path: String {
        switch self {
            
        }
    }
    
    var method: Moya.Method {
        switch self {
            
        }
    }
    
    var task: Task {
        switch self {
            
        }
    }
    
    var headers: [String : String]? {
        switch self {
            
        }
    }
}
