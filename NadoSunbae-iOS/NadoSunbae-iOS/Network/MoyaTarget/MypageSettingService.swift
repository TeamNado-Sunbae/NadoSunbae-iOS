//
//  MypageSettingService.swift
//  NadoSunbae-iOS
//
//  Created by madilyn on 2022/02/26.
//

import Foundation
import Moya

enum MypageSettingService {
    case editProfile(data: MypageEditProfileRequestBodyModel)
    case getLatestVersion
    case getBlockList
    case requestResetPW(email: String)
}

extension MypageSettingService: TargetType {
    var baseURL: URL {
        return URL(string: APIConstants.baseURL)!
    }
    
    var path: String {
        switch self {
        case .editProfile:
            return "/user/"
        case .getLatestVersion:
            return "/app/version/recent"
        case .getBlockList:
            return "/block/"
        case .requestResetPW:
            return "/auth/reset/password"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .editProfile:
            return .put
        case .getLatestVersion, .getBlockList:
            return .get
        case .requestResetPW:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .editProfile(let data):
            return .requestParameters(parameters: [
                "profileImageId": data.profileImageID,
                "nickname": data.nickname,
                "bio": data.bio,
                "isOnQuestion": data.isOnQuestion,
                "firstMajorId": data.firstMajorID,
                "firstMajorStart": data.firstMajorStart,
                "secondMajorId": data.secondMajorID,
                "secondMajorStart": data.secondMajorStart
            ], encoding: JSONEncoding.default)
        case .getLatestVersion, .getBlockList:
            return .requestPlain
        case .requestResetPW(let email):
            return .requestParameters(parameters: ["email": email], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .requestResetPW:
            return ["Content-type": "application/json"]
        default:
            let accessToken = UserToken.shared.accessToken ?? ""
            return ["accessToken": accessToken]
        }
    }
}
