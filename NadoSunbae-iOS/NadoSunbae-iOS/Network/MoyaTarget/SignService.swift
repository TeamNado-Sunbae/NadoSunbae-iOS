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
    case signUp(userData: SignUpBodyModel)
    case checkNickNameDuplicate(nickName: String)
    case checkEmailDuplicate(email: String)
}

extension SignService: TargetType {
    var baseURL: URL {
        return URL(string: APIConstants.baseURL)!
    }
    
    var path: String {
        switch self {
        case .signIn:
            return "/auth/login"
        case .signUp:
            return "/auth/signup"
        case .checkNickNameDuplicate:
            return "/auth/duplication-check/nickname"
        case .checkEmailDuplicate:
            return "/auth/duplication-check/email"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .signIn, .signUp, .checkNickNameDuplicate, .checkEmailDuplicate:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .signIn(let email, let PW, let deviceToken):
            return .requestParameters(parameters: ["email": email, "password": PW, "deviceToken": deviceToken], encoding: JSONEncoding.default)
        case .signUp(let userData):
            return .requestParameters(parameters: [
                "email": userData.email,
                "nickname": userData.nickName,
                "password": userData.PW,
                "universityId": userData.universityID,
                "firstMajorId": userData.firstMajorID,
                "firstMajorStart": userData.firstMajorStart,
                "secondMajorId": userData.secondMajorID,
                "secondMajorStart": userData.secondMajorStart
            ], encoding: JSONEncoding.default)
        case .checkNickNameDuplicate(let nickName):
            return .requestParameters(parameters: ["nickname": nickName], encoding: JSONEncoding.default)
        case .checkEmailDuplicate(let email):
            return .requestParameters(parameters: ["email": email], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
}
