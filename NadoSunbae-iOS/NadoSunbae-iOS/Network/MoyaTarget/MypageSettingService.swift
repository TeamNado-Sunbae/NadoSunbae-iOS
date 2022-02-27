//
//  MypageSettingService.swift
//  NadoSunbae-iOS
//
//  Created by madilyn on 2022/02/26.
//

import Foundation
import Moya

enum MypageSettingService {
    case editProfile(data: EditProfileRequestModel)
    case getLatestVersion
}

extension MypageSettingService: TargetType {
    var baseURL: URL {
        return URL(string: APIConstants.baseURL)!
    }
    
    var path: String {
        switch self {
        case .editProfile:
            return "/user/mypage"
        case .getLatestVersion:
            return "/user/mypage/app-version/recent"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .editProfile:
            return .put
        case .getLatestVersion:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .editProfile(let data):
            return .requestParameters(parameters: [
                "nickname": data.nickName,
                "firstMajorId": data.firstMajorID,
                "firstMajorStart": data.firstMajorStart,
                "secondMajorId": data.secondMajorID,
                "secondMajorStart": data.secondMajorStart,
                "isOnQuestion": data.isOnQuestion
            ], encoding: JSONEncoding.default)
        case .getLatestVersion:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        let accessToken = UserDefaults.standard.string(forKey: UserDefaults.Keys.AccessToken)!
        return ["accessToken": accessToken]
    }
}
