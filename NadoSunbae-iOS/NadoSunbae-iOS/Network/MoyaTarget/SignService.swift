//
//  SignService.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/01/20.
//

import Foundation
import Moya

enum SignService {
    case requestSignIn(email: String, PW: String, deviceToken: String)
    case requestSignUp(userData: SignUpBodyModel)
    case checkNickNameDuplicate(nickName: String)
    case checkEmailDuplicate(email: String)
    case requestSignOut
    case requestWithDraw(PW: String)
    case resendSignUpMail(email: String, PW: String)
    case updateToken(refreshToken: String)
    case getUnivEmailDomain(univID: Int)
}

extension SignService: TargetType {
    var baseURL: URL {
        return URL(string: APIConstants.baseURL)!
    }
    
    var path: String {
        switch self {
        case .requestSignIn:
            return "/auth/login"
        case .requestSignUp:
            return "/auth/signup"
        case .checkNickNameDuplicate:
            return "/auth/duplication-check/nickname"
        case .checkEmailDuplicate:
            return "/auth/duplication-check/email"
        case .requestSignOut:
            return "/auth/logout"
        case .requestWithDraw:
            return "/auth/secession"
        case .resendSignUpMail:
            return "/auth/certification/email"
        case .updateToken:
            return "/auth/renewal/token"
        case .getUnivEmailDomain(let univID):
            return "auth/university/\(univID)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .requestSignIn, .requestSignUp, .checkNickNameDuplicate, .checkEmailDuplicate, .requestSignOut, .resendSignUpMail, .requestWithDraw, .updateToken:
            return .post
        case .getUnivEmailDomain:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .requestSignIn(let email, let PW, let deviceToken):
            return .requestParameters(parameters: ["email": email, "password": PW, "deviceToken": deviceToken], encoding: JSONEncoding.default)
        case .requestSignUp(let userData):
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
        case .requestSignOut, .updateToken, .getUnivEmailDomain:
            return .requestPlain
        case .requestWithDraw(let PW):
            return .requestParameters(parameters: ["password": PW], encoding: JSONEncoding.default)
        case .resendSignUpMail(let email, let PW):
            return .requestParameters(parameters: ["email": email, "password": PW], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .requestSignOut, .requestWithDraw:
            let accessToken = UserToken.shared.accessToken ?? ""
            return ["accessToken": accessToken]
        case .updateToken(let refreshToken):
            return ["refreshToken": refreshToken]
        default:
            return ["Content-type": "application/json"]
        }
    }
}
