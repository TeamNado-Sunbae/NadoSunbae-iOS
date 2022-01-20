//
//  SignService.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/01/20.
//

import Foundation
import Moya

enum SignService {
    case signIn(email: String, PW: String, deviceToken: String)
}

extension SignService: TargetType {
    var baseURL: URL {
        return URL(string: APIConstants.baseURL)!
    }
    
    var path: String {
        switch self {
        case .signIn:
            return "/auth/login"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .signIn:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .signIn(let email, let PW, let deviceToken):
            return .requestParameters(parameters: ["userId": userID], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        let accessToken = UserDefaults.standard.value(forKey: UserDefaults.Keys.AccessToken) as! String
        return ["accessToken": accessToken]
    }
}
